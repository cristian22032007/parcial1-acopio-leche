#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Validacion do
  @dia_min 1
  @dia_max 6
  @litros_max 800
  @grasa_min 0
  @grasa_max 15


  def validar_entrega(entrega, productores, tanques) do
    with :ok <- validar_productor(entrega, productores),
         :ok <- validar_tanque(entrega, tanques),
         :ok <- validar_dia(entrega),
         :ok <- validar_litros(entrega),
         :ok <- validar_grasa(entrega) do
      {:ok, entrega}
    end
  end

  defp validar_productor(entrega, productores) do
    # ¿algún productor tiene codigo == entrega.productor?
    # Pista: Enum.any?/2
  end

  defp validar_tanque(entrega, tanques) do
    # igual, pero con id
  end

  defp validar_dia(entrega) do
    # Pista: is_integer/1 y comparación de rango
  end

  defp validar_litros(entrega) do
    # Pista: is_number/1, > 0 y <= @litros_max
  end

  defp validar_grasa(entrega) do
    # Pista: is_number/1, >= 0 y <= 15
  end
end
