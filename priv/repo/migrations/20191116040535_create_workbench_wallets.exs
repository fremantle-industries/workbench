defmodule Workbench.Repo.Migrations.CreateWorkbenchWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add(:name, :string, null: false)
      add(:asset, :string, null: false)
      add(:amount, :decimal, null: false)
      add(:address, :string, null: false)

      timestamps()
    end

    create(unique_index(:wallets, [:name, :asset]))
  end
end
