defmodule Feedya.HN.Subscription do
  use Feedya.Web, :model

  alias Ecto.Changeset
  alias Feedya.{Repo, HN.Subscription, HN.Story, User, Email, Mailer}

  @required [:terms, :name, :user_id]

  schema "hn_subscriptions" do
    field :name, :string
    field :terms, {:array, :string}
    field :indexed_at, :naive_datetime
    belongs_to :user, User
    many_to_many :stories, Story, join_through: "hn_subscription_stories"

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

  def by_user(q, user) do
    from s in q,
    where: s.user_id == ^user.id,
    preload: [:stories]
  end

  def index!(sub_id) do
    subscription = Repo.get!(Subscription, sub_id)
    
    matched = subscription.terms
              |> Enum.flat_map(&find_matched(&1, subscription.indexed_at))
              |> Enum.uniq_by(fn s -> s.id end)

    Repo.transaction(fn ->
      case matched do
        [] -> :ok
        _ ->  subscription
              |> Repo.preload([:stories, :user])
              |> save_matched_stories!(matched)
              |> new_stories_mail!(matched)
      end
    end)
  end

  ### Implementation ###

  defp new_stories_mail!(subscription, new_stories) do
    user = subscription.user

    user.email
    |> Email.new_stories(new_stories)
    |> Mailer.deliver_later
  end


  defp find_matched(term, nil) do
    Story
    |> Story.search(term)
    |> Repo.all
  end
  defp find_matched(term, indexed_at) do
    Story
    |> Story.search(term)
    |> Story.since(indexed_at)
    |> Repo.all
  end

  defp save_matched_stories!(subscription, stories) do
    subscription
    |> change
    |> put_assoc(:stories, stories)
    |> put_change(:indexed_at, Ecto.DateTime.utc)
    |> unique_constraint(:stories, message: "Story already present in subscription.")
    |> Repo.update!
  end
end
