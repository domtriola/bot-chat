defmodule Chat.User do
  use Chat.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_digest, :string

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:username])
    |> validate_required([:username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def registration_changeset(model, params \\ %{}) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_password_digest()
  end

  defp put_password_digest(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(
          changeset, :password_digest, Comeonin.Bcrypt.hashpwsalt(password)
        )
      _else ->
        changeset
    end
  end
end
