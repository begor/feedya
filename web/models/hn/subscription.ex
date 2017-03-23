defmodule Feedya.HN.Subscription do
  use Feedya.Web, :model

  alias Ecto.Changeset
  alias Feedya.{Repo, HN.Subscription, HN.Story, User}

  @required [:terms, :name, :user_id]

  schema "hn_subscriptions" do
    field :name, :string
    field :terms, {:array, :string}
    belongs_to :user, User
    many_to_many :stories, Story, join_through: "hn_subscription_stories", on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
  end

  def by_user(user) do
    query = from p in Subscription,
            where: p.user_id == ^user.id,
            select: p,
            preload: [:stories]
    Repo.all(query)
  end

  def index!(subscription) do
    terms = subscription.terms

    matched = terms
              |> Enum.flat_map(&find_matched(&1, subscription.updated_at))
              |> Enum.uniq

    save_matched_stories!(subscription, matched)
  end

  ### Implementation ###

  defp find_matched(term, nil) do
    Story
    |> Story.search(term)
    |> Repo.all
  end

  defp find_matched(term, indexed_at) do
    Story
    |> Story.since(indexed_at)
    |> Story.search(term)
    |> Repo.all
  end

  defp save_matched_stories!(subscription, stories) do
    subscription = Repo.preload(subscription, :stories)

    subscription
    |> Changeset.change
    |> Changeset.put_assoc(:stories, subscription.stories ++ stories)
    |> Repo.update!(force: true)
  end
end
