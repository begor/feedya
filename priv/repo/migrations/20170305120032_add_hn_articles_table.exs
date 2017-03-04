defmodule Feedya.Repo.Migrations.AddHnArticlesTable do
  use Ecto.Migration

  def change do
    create table(:hn_stories) do
      add :hn_id, :integer
      add :url, :string
      add :title, :string
      add :author, :string
      add :score, :integer

      timestamps()
    end

    create unique_index(:hn_stories, [:hn_id])
    create index(:hn_stories, [:title])
  end
end
