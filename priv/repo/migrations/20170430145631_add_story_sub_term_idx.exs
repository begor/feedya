defmodule Feedya.Repo.Migrations.AddStorySubTermIdx do
  use Ecto.Migration

  def change do
    create unique_index(:hn_subscription_stories, [:story_id, :subscription_id, :matched_by])
  end
end
