defmodule Feedya.Repo.Migrations.AddMatchedByToSubscriptionStories do
  use Ecto.Migration

  def change do
    alter table(:hn_subscription_stories) do
      add :matched_by, :string
    end
  end
end
