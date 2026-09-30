#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Reportes do
  Code.require_file("liquidacion.exs")

  @meta_diaria 2000

   @motivos_rechazo [
    :productor_desconocido,
    :tanque_desconocido,
    :dia_invalido,
    :litros_fuera_de_rango,
    :porcentaje_invalido
  ]

  @doc """
  R1: Entregas rechazadas con su motivo y cantidad de rechazos por cada motivo.
  """
  def reporte_r1(entregas, productores, tanques) do
  rechazadas_con_motivo =
    Enum.flat_map(entregas, fn entrega ->
      case Validacion.validar_entrega(entrega, productores, tanques) do
        {:error, motivo} -> [{entrega, motivo}]
        {:ok, _} -> []
      end
    end)

  conteo_motivos =
    Enum.reduce(@motivos_rechazo, %{}, fn motivo, acc ->
      Map.put(acc, motivo, 0)
    end)

  conteo_motivos =
    Enum.reduce(rechazadas_con_motivo, conteo_motivos, fn {_entrega, motivo}, acc ->
      Map.update!(acc, motivo, &(&1 + 1))
    end)

  %{
    entregas_rechazadas: rechazadas_con_motivo,
    conteo: conteo_motivos
  }
end

  @doc """
  R2: Litros almacenados por tanque y porcentaje de ocupación respecto de su capacidad.
  """
  def reporte_r2(tanques, entregas_validas) do
    tanques
    |> Enum.map(fn tanque ->
      entregas_tanque = Enum.filter(entregas_validas, &(&1.tanque == tanque.id))
      litros = Enum.sum(Enum.map(entregas_tanque, & &1.litros))
      porcentaje = (litros / tanque.capacidad) * 100

      %{
        id: tanque.id,
        nombre: tanque.nombre,
        litros: litros,
        capacidad: tanque.capacidad,
        porcentaje: porcentaje
      }
    end)
    |> Enum.sort_by(& &1.porcentaje, :desc)
  end

  @doc """
  R3: Litros recibidos por el centro en cada uno de los 6 días y cumplimiento de meta.
  """
  def reporte_r3(entregas_validas) do
    dias = 1..6

    litros_por_dia =
      Enum.map(dias, fn dia ->
        entregas_dia = Enum.filter(entregas_validas, &(&1.dia == dia))
        litros = Enum.sum(Enum.map(entregas_dia, & &1.litros))
        cumplio = litros >= @meta_diaria
        {dia, litros, cumplio}
      end)

    cumplio_todos = Enum.all?(litros_por_dia, fn {_d, _l, cumplio} -> cumplio end)
    cumplio_al_menos_uno = Enum.any?(litros_por_dia, fn {_d, _l, cumplio} -> cumplio end)

    %{
      detalle_dias: litros_por_dia,
      cumplio_todos: cumplio_todos,
      cumplio_al_menos_uno: cumplio_al_menos_uno
    }
  end

  @doc """
  R4: Liquidación de todos los productores ordenada por pago neto de mayor a menor.
  """
  def reporte_r4(productores, entregas_validas) do
    liquidaciones = Liquidacion.liquidar_todos(entregas_validas, productores)

    liquidaciones
    |> Enum.sort_by(& &1.neto, :desc)
    |> Enum.with_index(1)
    |> Enum.map(fn {liq, posicion} -> Map.put(liq, :posicion, posicion) end)
  end

  @doc """
  R5: Productor con mayor cantidad de litros entregados cada día (maneja empates)
  y quién ocupó el primer lugar en más días.
  """
  def reporte_r5(productores, entregas_validas) do
    dias_detalle =
      Enum.map(1..6, fn dia ->
        entregas_dia = Enum.filter(entregas_validas, &(&1.dia == dia))

        litros_por_prod =
          entregas_dia
          |> Enum.group_by(& &1.productor, & &1.litros)
          |> Enum.map(fn {p_code, lista_l} -> {p_code, Enum.sum(lista_l)} end)

        if litros_por_prod == [] do
          %{dia: dia, max_litros: 0, ganadores: []}
        else
          max_litros = Enum.map(litros_por_prod, fn {_p, l} -> l end) |> Enum.max()

          ganadores_codigos =
            litros_por_prod
            |> Enum.filter(fn {_p, l} -> l == max_litros end)
            |> Enum.map(fn {p, _l} -> p end)

          ganadores = Enum.filter(productores, &(&1.codigo in ganadores_codigos))

          %{dia: dia, max_litros: max_litros, ganadores: ganadores}
        end
      end)

    conteo_primeros =
      dias_detalle
      |> Enum.flat_map(fn d -> Enum.map(d.ganadores, & &1.codigo) end)
      |> Enum.reduce(%{}, fn p_code, acc -> Map.update(acc, p_code, 1, &(&1 + 1)) end)

    max_dias =
      if conteo_primeros == %{} do
        0
      else
        conteo_primeros |> Map.values() |> Enum.max()
      end

    mas_dias_codigos =
      conteo_primeros
      |> Enum.filter(fn {_p, count} -> count == max_dias end)
      |> Enum.map(fn {p, _c} -> p end)

    mas_dias_productores = Enum.filter(productores, &(&1.codigo in mas_dias_codigos))

    %{
      detalle_dias: dias_detalle,
      mas_dias_primer_lugar: mas_dias_productores,
      dias_ganados: max_dias
    }
  end

  @doc """
  R6: Productor con mejor calidad (mayor grasa ponderada) entre quienes tengan
  al menos 3 entregas válidas.
  """
  def reporte_r6(productores, entregas_validas) do
    candidatos =
      productores
      |> Enum.map(fn prod ->
        entregas_prod = Enum.filter(entregas_validas, &(&1.productor == prod.codigo))

        if length(entregas_prod) >= 3 do
          total_litros = Enum.sum(Enum.map(entregas_prod, & &1.litros))

          grasa_ponderada =
            entregas_prod
            |> Enum.map(fn e -> e.litros * e.grasa end)
            |> Enum.sum()

          promedio = if total_litros > 0, do: grasa_ponderada / total_litros, else: 0.0

          %{productor: prod, num_entregas: length(entregas_prod), promedio_grasa: promedio}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    if candidatos != [] do
      Enum.max_by(candidatos, & &1.promedio_grasa)
    else
      %{productor: nil, promedio_grasa: 0.0}
    end
  end

  @doc """
  R7: Total pagado por el centro durante la semana y costo promedio pagado por litro.
  """
  def reporte_r7(productores, entregas_validas) do
    liquidaciones = Liquidacion.liquidar_todos(entregas_validas, productores)
    total_pagado = Enum.sum(Enum.map(liquidaciones, & &1.neto))
    total_litros = Enum.sum(Enum.map(entregas_validas, & &1.litros))

    costo_promedio = if total_litros > 0, do: total_pagado / total_litros, else: 0.0

    %{
      total_pagado: total_pagado,
      total_litros: total_litros,
      costo_promedio_por_litro: costo_promedio
    }
  end

  @doc """
  R8: Productores que realizaron al menos una entrega válida en todos los tanques.
  """
  def reporte_r8(productores, tanques, entregas_validas) do
    total_tanques_count = length(tanques)

    Enum.filter(productores, fn prod ->
      tanques_usados =
        entregas_validas
        |> Enum.filter(&(&1.productor == prod.codigo))
        |> Enum.map(& &1.tanque)
        |> Enum.uniq()

      length(tanques_usados) == total_tanques_count
    end)
  end
end
