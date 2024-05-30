defmodule MedPet.Helpers.Regex do
  defmodule User do
    @spec cpf() :: Regex.t()
    def cpf(), do: ~r"^[0-9]{11}$"

    @spec tel() :: Regex.t()
    def tel(), do: ~r"^\+[0-9]{13}$"

    @spec email() :: Regex.t()
    def email(), do: ~r"^\S+@\S+.\S+$"
  end
end
