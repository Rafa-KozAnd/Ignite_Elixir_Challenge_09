defmodule Rockelivery.Repo.Migrations.CreateOrdersTable do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :address, :string
      add :comments, :string
      add :payment_method, :payment_method
      add :user_id, references(:users, type: :binary_id, on_delete: :nilify_all)

      timestamps()
    end
  end
end
