#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Liquidacion do
  @tarifa_base 1800
  @litros_bonificacion 450
  @bonificacion_diaria 25000
  @costo_transporte 18000
  @grasa_bonificacion 3.5
  @grasa_sin_ajuste 3.0
  @grasa_descuento_medio 2.5
  @factor_bonificacion_grasa 1.06
  @factor_descuento_medio 0.92
  @factor_descuento_alto 0.8

  @doc """
  Calcula la liquidación semanal de todos los productores.

  Recorre la lista de productores (y no la de entregas) para que ninguno
  quede por fuera, incluso los que no tienen entregas válidas. Aplica
  `liquidar_productor/2` a cada uno.

  Devuelve una lista de mapas, uno por productor, en el mismo orden de la
  lista original. No ordena el resultado; el orden para R4 se hace en el
  módulo de reportes.
  """
  def liquidar_todos(entregas, productores) do
    Enum.map(productores, fn productor -> liquidar_productor(entregas, productor) end)
  end

  @doc """
  Calcula la liquidación semanal de un productor.

  Recibe la lista de entregas válidas (de todos los productores) y el mapa
  de un productor. Se queda con las entregas de ese productor y calcula:
  litros totales, valor de las entregas (según la grasa), bonificaciones por
  volumen diario y descuento de transporte.

  Un productor sin entregas válidas devuelve todos los valores en cero.

  Devuelve un mapa con las claves `:codigo`, `:nombre`, `:litros`,
  `:valor_entregas`, `:bonificaciones`, `:transporte` y `:neto`.
  """
  def liquidar_productor(entregas, productor) do
    entrega_individual = Util2.aplicar_filtro(entregas, &(&1.productor == productor.codigo))

    litros = entrega_individual |> Enum.map(fn entrega -> entrega.litros end) |> Enum.sum()
    valor = entrega_individual |> Enum.map(fn entrega -> valor_entrega(entrega) end) |> Enum.sum()

    totales_dia = litros_diarios(entrega_individual)

    bonificaciones =
      totales_dia
      |> Enum.map(fn {_, total} -> bonificacion_diaria(total) end)
      |> Enum.sum()

    transporte = descuento_transporte(productor, length(totales_dia))

    %{
      codigo: productor.codigo,
      nombre: productor.nombre,
      litros: litros,
      valor_entregas: valor,
      bonificaciones: bonificaciones,
      transporte: transporte,
      neto: valor + bonificaciones - transporte
    }
  end

  @doc """
  Devuelve el detalle de un productor día por día: litros, valor de las
  entregas y bonificación de ese día, ordenado por día.

  Recibe únicamente las entregas válidas de ese productor. Los días sin
  entregas no aparecen.
  """
  def detalle_por_dia(entregas_productor) do
    entregas_productor
    |> Enum.group_by(fn e -> e.dia end)
    |> Enum.map(fn {dia, entregas_dia} ->
      litros = entregas_dia |> Enum.map(fn e -> e.litros end) |> Enum.sum()
      valor = entregas_dia |> Enum.map(&valor_entrega/1) |> Enum.sum()
      %{dia: dia, litros: litros, valor: valor, bonificacion: bonificacion_diaria(litros)}
    end)
    |> Util2.ordenar(:asc, fn d -> d.dia end)
  end

  defp litros_diarios(entregas_productor) do
    entregas_productor
    |> Enum.group_by(fn e -> e.dia end, fn e -> e.litros end)
    |> Enum.map(fn {dia, lista_litros} -> {dia, Enum.sum(lista_litros)} end)
  end

  defp bonificacion_diaria(total_litros) do
    if total_litros >= @litros_bonificacion do
      @bonificacion_diaria
    else
      0
    end
  end

  def valor_entrega(entrega) do
    base = entrega.litros * @tarifa_base

    cond do
      entrega.grasa >= @grasa_bonificacion -> base * @factor_bonificacion_grasa
      entrega.grasa >= @grasa_sin_ajuste -> base
      entrega.grasa >= @grasa_descuento_medio -> base * @factor_descuento_medio
      true -> base * @factor_descuento_alto
    end
  end

  defp descuento_transporte(productor, dias_con_entrega) do
    if productor.transporte do
      @costo_transporte * dias_con_entrega
    else
      0
    end
  end
end
