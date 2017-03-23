defmodule Feedya.Repo.Migrations.CreateHNSubscriptionStory do
  use Ecto.Migration

  def change do
    create table(:hn_subscription_stories) do
      add :story_id, references(:hn_stories, on_delete: :delete_all)
      add :subscription_id, references(:hn_subscriptions, on_delete: :delete_all)
    end
    create index(:hn_subscription_stories, [:story_id])
    create index(:hn_subscription_stories, [:subscription_id])
    create unique_index(:hn_subscription_stories, [:story_id, :subscription_id])
  end
end
