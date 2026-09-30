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

  @doc """
  Valida una entrega aplicando las cinco reglas en orden, encadenadas con `with`.

  Recibe la entrega, la lista de productores y la lista de tanques.
  Se detiene en la primera regla que falle.

  Devuelve {:ok, entrega} si cumple todas las reglas, o {:error, motivo}
  con uno de estos motivos: :productor_desconocido, :tanque_desconocido,
  :dia_invalido, :litros_fuera_de_rango o :porcentaje_invalido.
  """
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
    if is_number(entrega.litros) do
      if entrega.litros > 0 and entrega.litros <= @litros_max do
        :ok
      else
       {:error, :litros_fuera_de_rango}
      end
    else
     {:error, :litros_fuera_de_rango}
    end
  end

  defp validar_grasa(entrega) do
    if is_number(entrega.grasa) do
      if entrega.grasa >= @grasa_min and entrega.grasa <= @grasa_max do
        :ok
      else
        {:error, :porcentaje_invalido}
      end
    else
      {:error, :porcentaje_invalido}
    end
  end
 end
