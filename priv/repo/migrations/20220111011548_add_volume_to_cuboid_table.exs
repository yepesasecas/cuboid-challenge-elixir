defmodule App.Repo.Migrations.AddVolumeToCuboidTable do
  use Ecto.Migration

  def change do
    alter table(:cuboids) do
      add :volume, :integer
    end
  end
end
