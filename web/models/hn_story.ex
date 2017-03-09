defmodule Feedya.HNStory do
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
  end

  def already_fetched(ids) do
    Repo.all(
      from s in Feedya.HNStory,
      where: s.hn_id in ^ids,
      select: s.hn_id
    )
  end

  def new!(story) do
    Repo.insert!(Feedya.HNStory.changeset(%Feedya.HNStory{}, story))
  end

  def get_story!(id) do
    {:ok, story} = HN.story(id)
    story
  end

  def fetch_new! do
    fetch_many!(&HN.new_ids/0)
  end

  def fetch_top! do
    fetch_many!(&HN.top_ids/0)
  end

  def fetch_best! do
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

  defp fetch_many!(api_func) do
    {:ok, ids} = api_func.()
    ids_to_fetch = ids -- already_fetched(ids)
    for id <- ids_to_fetch, do: spawn(
      fn ->
        id
        |> get_story!
        |> new!
      end)
  end
end
