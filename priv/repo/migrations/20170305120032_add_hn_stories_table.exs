defmodule Feedya.Repo.Migrations.AddHnStoriesTable do
  use Ecto.Migration

  def change do
    create table(:hn_stories) do
      add :hn_id, :integer
      add :url, :text
      add :title, :string
      add :author, :string
      add :score, :integer
      add :type, :string

      timestamps()
    end

    create unique_index(:hn_stories, [:hn_id])
    add_fts_indexes()
  end

  defp add_fts_indexes do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX hn_stories_title_trgm_index ON hn_stories USING gin (title gin_trgm_ops);"
    execute "CREATE INDEX hn_stories_url_trgm_index ON hn_stories USING gin (url gin_trgm_ops);"
  end
end
