defmodule Feedya.Repo.Migrations.AddIndexedAtToSubsctiptions do
  use Ecto.Migration

  def change do
    alter table(:hn_subscriptions) do
      add :indexed_at, :datetime
    end
  end
end
