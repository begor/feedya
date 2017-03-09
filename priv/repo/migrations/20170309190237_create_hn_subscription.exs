defmodule Feedya.Repo.Migrations.CreateHNSubscription do
  use Ecto.Migration

  def change do
    create table(:hn_subscriptions) do
      add :name, :string
      add :terms, {:array, :string}
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:hn_subscriptions, [:user_id])
    create unique_index(:hn_subscriptions, [:user_id, :name])
  end
end
