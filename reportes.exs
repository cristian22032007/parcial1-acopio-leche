#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Reportes do
  Code.require_file("liquidacion.exs")

  @meta_diaria 2000

  @doc """
  R1: Entregas rechazadas con su motivo y cantidad de rechazos por motivo.
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
      Enum.reduce(rechazadas_con_motivo, %{}, fn {_entrega, motivo}, acc ->
        Map.update(acc, motivo, 1, &(&1 + 1))
      end)

    %{entregas_rechazadas: rechazadas_con_motivo, conteo: conteo_motivos}
  end

  @doc """
  R2: Litros almacenados por tanque y porcentaje de ocupación.
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
  R3: Litros recibidos por el centro en cada uno de los 6 días y cumplimiento de meta (2000L).
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
  R5: Productores que entregaron leche en los 6 días y los que no entregaron ningún día.
  """
  def reporte_r5(productores, entregas_validas) do
    entregaron_todos =
      Enum.filter(productores, fn prod ->
        dias_entrega =
          entregas_validas
          |> Enum.filter(&(&1.productor == prod.codigo))
          |> Enum.map(& &1.dia)
          |> Enum.uniq()

        length(dias_entrega) == 6
      end)

    ningun_dia =
      Enum.filter(productores, fn prod ->
        !Enum.any?(entregas_validas, &(&1.productor == prod.codigo))
      end)

    %{entregaron_todos_los_dias: entregaron_todos, ningun_dia: ningun_dia}
  end

  @doc """
  R6: Productor con el mayor promedio de grasa por litro entregado.
  """
  def reporte_r6(productores, entregas_validas) do
    promedios =
      productores
      |> Enum.map(fn prod ->
        entregas_prod = Enum.filter(entregas_validas, &(&1.productor == prod.codigo))
        total_litros = Enum.sum(Enum.map(entregas_prod, & &1.litros))

        if total_litros > 0 do
          # Promedio ponderado de grasa por litro
          grasa_ponderada =
            entregas_prod
            |> Enum.map(fn e -> e.litros * e.grasa end)
            |> Enum.sum()

          promedio = grasa_ponderada / total_litros
          %{productor: prod, promedio_grasa: promedio}
        else
          %{productor: prod, promedio_grasa: 0.0}
        end
      end)

    Enum.max_by(promedios, & &1.promedio_grasa)
  end
end
