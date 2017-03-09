defmodule Feedya.Repo.Migrations.AddTypeToHnStories do
  use Ecto.Migration

  def change do
    alter table(:hn_stories) do
      add :type, :string
    end

    create index(:hn_stories, [:type])
  end
end
