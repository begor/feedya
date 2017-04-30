defmodule Feedya.Repo.Migrations.RemoveUniqIdxOnStorySub do
  use Ecto.Migration

  def change do
    drop index(:hn_subscription_stories, [:story_id, :subscription_id])
  end
end
