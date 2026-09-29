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
    if Enum.any?(productores, &(&1.codigo == entrega.productor)) do
      :ok
    else
      {:error, :productor_desconocido}
    end
  end

  defp validar_tanque(entrega, tanques) do
    if Enum.any?(tanques, &(&1.id == entrega.tanque)) do
      :ok
    else
      {:error, :tanque_desconocido}
    end
  end

  defp validar_dia(entrega) do
    if is_integer(entrega.dia) do
      if entrega.dia >= @dia_min and entrega.dia <= @dia_max do
        :ok
      else
        {:error, :dia_invalido}
      end
    else
      {:error, :dia_invalido}
    end
  end

  defp validar_litros(entrega) do
    # Pista: is_number/1, > 0 y <= @litros_max
  end

  defp validar_grasa(entrega) do
    # Pista: is_number/1, >= 0 y <= 15
  end
end
