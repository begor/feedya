defmodule Feedya.Repo.Migrations.TextInsteadOfString do
  use Ecto.Migration

  def change do
    alter table(:hn_stories) do
      modify :url, :text
    end
  end
end
