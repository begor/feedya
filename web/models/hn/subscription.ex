defmodule Feedya.HN.Subscription do
  use Feedya.Web, :model

  alias Ecto.Changeset
  alias Feedya.{Repo, User, Email, Mailer}
  alias Feedya.HN.{MatchedStory, Subscription, Story}

  @required [:terms, :name, :user_id]

  schema "hn_subscriptions" do
    field :name, :string
    field :terms, {:array, :string}
    field :indexed_at, :naive_datetime
    belongs_to :user, User
    has_many :matched_stories, MatchedStory

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
    preload: [matched_stories: :story]
  end

  def index!(sub_id) do
    subscription = Repo.get!(Subscription, sub_id)
    
    matched = Enum.reduce(
        subscription.terms,
        %{}, 
        fn t, acc -> 
          Map.put(acc, t, find_matched(t, subscription.indexed_at))
        end
    )

    Repo.transaction(fn ->
      subscription = Repo.preload(subscription, [:matched_stories, :user])
      
       
      new = Enum.reduce(matched, 
                         [],
                         fn ({t, matched}, acc) -> 
                            save_matched_stories!(subscription, t, matched)
                            acc ++ matched
                         end)
      new_stories_mail!(new, subscription)
      :ok
    end)
  end

  ### Implementation ###

  defp new_stories_mail!(new_stories, subscription) do
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

  defp save_matched_stories!(subscription, term, stories) do
    matched = Enum.map(
      stories, 
      fn s -> 
        %{story_id: s.id, subscription_id: subscription.id, matched_by: term}
      end)
    Repo.insert_all(MatchedStory, matched)
  end
end
