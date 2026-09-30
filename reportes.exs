#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Reportes do
  Code.require_file("liquidacion.exs")

  # R1: Entregas rechazadas con su motivo y cantidad de rechazos por motivo
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

  # R2: Litros almacenados por tanque y porcentaje de ocupación
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
end
