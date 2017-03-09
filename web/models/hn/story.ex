defmodule Feedya.HN.Story do
  use Feedya.Web, :model

  alias Feedya.API.HN
  alias Feedya.Repo

  schema "hn_stories" do
    field :hn_id, :integer
    field :url, :string
    field :title, :string
    field :author, :string
    field :score, :integer
    field :type, :string

    field :by, :string, virtual: true

    timestamps()
  end

  ## Interface ##

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :url, :title, :by, :score, :type])
    |> validate_required([:id, :title, :by, :score, :type])
    |> map_fields
    |> unique_constraint(:hn_id)
  end

  def since(q, datetime) do
    from s in q,
    where: s.inserted_at > ^datetime
  end

  def search(q, search_term, limit \\ 0.15) do
    from s in q,
    where: fragment("similarity(?, ?) > ?", s.title, ^search_term, ^limit)
  end

  def already_fetched(ids) do
    Repo.all(
      from s in Feedya.HN.Story,
      where: s.hn_id in ^ids,
      select: s.hn_id
    )
  end

  def max_fetched do
    Repo.one(from s in Feedya.HNStory, select: max(s.hn_id)) || 0
  end

  def create!(story) do
    Repo.insert!(Feedya.HNStory.changeset(%Feedya.HNStory{}, story))
  end

  def save_new! do
    fetch_many!(&HN.new_ids/0)
  end

  def save_top! do
    fetch_many!(&HN.top_ids/0)
  end

  def save_best! do
    fetch_many!(&HN.best_ids/0)
  end

  ## Implementation ##

  defp map_fields(changeset) do
    hn_id = get_change(changeset, :id)
    author = get_change(changeset, :by)

    changeset
    |> delete_change(:id)
    |> delete_change(:by)
    |> put_change(:author, author)
    |> put_change(:hn_id, hn_id)
  end

  defp fetch_many!(get_ids) do
    max_id = max_fetched
    ids = get_ids.()
    to_fetch = ids -- already_fetched(ids)

    to_fetch
    |> Flow.from_enumerable
    |> Flow.partition(stages: 100)
    |> Flow.map(&HN.story/1)
    |> Flow.partition(stages: 100)
    |> Flow.map(&create!/1)
    |> Flow.run
  end
end
