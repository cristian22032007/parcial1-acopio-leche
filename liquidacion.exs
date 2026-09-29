#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Liquidacion do
  @tarifa_base 1800
  @litros_bonificacion 450
  @bonificacion_diaria 25000
  @costo_transporte 18000


  defp litrosDiarios(entregas, productor) do
    entregas
    |> Enum.filter(fn entrega -> entrega.productor == productor.codigo end)
    |> Enum.group_by(fn entrega -> entrega.dia end, fn entrega -> entrega.litros end)
    |> Enum.map(fn {dia, litros} -> {dia, Enum.sum(litros)} end)
  end

#El valor diario acumulado de las entragas que superaron el limite de litros para bonificación
   defp bonificaciondiaria(total_litros) do
    if total_litros >= @litros_bonificacion do
      @bonificacion_diaria
    else
      0
    end
  end

#El valor inicial de una entrega válida y se modifica de acuerdo con el porcentaje de grasa
 defp valor_entrega(entrega) do
    base = entrega.litros * @tarifa_base

    cond do
      entrega.grasa >= 3.5 -> base * 1.06
      entrega.grasa >= 3.0 -> base
      entrega.grasa >= 2.5 -> base * 0.92
      true -> base * 0.80
    end
  end

# El valor del descuento al centro por el prestamo del servicio de transporte
  defp descuentotransporte(productor, dias_con_entrega) do
    if productor.transporte do
      @costo_transporte * dias_con_entrega
    else
      0
    end
  end

end
