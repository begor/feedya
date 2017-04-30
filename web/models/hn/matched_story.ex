defmodule Feedya.HN.MatchedStory do
  use Feedya.Web, :model

  alias Ecto.Changeset
  alias Feedya.HN.{Story, Subscription}

  @required [:matched_by, :story_id, :subscription_id]

  schema "hn_subscription_stories" do
    field :matched_by, :string
    belongs_to :story, Story
    belongs_to :subscription, Subscription
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
