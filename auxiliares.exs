#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Auxiliares do
  @tarifa_base 1800
  @grasa_bonificacion 3.5
  @grasa_sin_ajuste 3.0
  @grasa_descuento_medio 2.5
  @factor_bonificacion_grasa 1.06
  @factor_descuento_medio 0.92
  @factor_descuento_alto 0.8
  @litros_bonificacion 450
  @bonificacion_diaria 25000

  @doc """
  Parsea la cadena de texto de una entrega adicional.
  Formato esperado: productor;tanque;dia;litros;grasa
  """
  def parsear_entrega_adicional(linea) do
    linea_limpia = String.trim(linea)

    if linea_limpia == "" do
      :omitir
    else
      partes = String.split(linea_limpia, ~r/[;,\s:]+/)

      case partes do
        [prod, tanque, dia_str, litros_str, grasa_str] ->
          with {dia, ""} <- Integer.parse(dia_str),
               {litros, _} <- Float.parse(litros_str),
               {grasa, _} <- Float.parse(grasa_str) do
            {:ok, %{productor: prod, tanque: tanque, dia: dia, litros: litros, grasa: grasa}}
          else
            _ -> {:error, :formato_invalido}
          end

        _ ->
          {:error, :formato_invalido}
      end
    end
  end

  @doc """
  Calcula el valor de una entrega individual según el porcentaje de grasa.
  """
  def valor_entrega(entrega) do
    base = entrega.litros * @tarifa_base

    cond do
      entrega.grasa >= @grasa_bonificacion -> base * @factor_bonificacion_grasa
      entrega.grasa >= @grasa_sin_ajuste -> base
      entrega.grasa >= @grasa_descuento_medio -> base * @factor_descuento_medio
      true -> base * @factor_descuento_alto
    end
  end

  @doc """
  Imprime el comprobante semanal de un productor según su código.
  """
  def imprimir_comprobante(codigo_productor, productores, entregas_validas) do
    productor = Enum.find(productores, &(&1.codigo == codigo_productor))

    if is_nil(productor) do
      IO.puts("\n[!] El código de productor '#{codigo_productor}' no existe.")
    else
      liq = Liquidacion.liquidar_productor(entregas_validas, productor)
      entregas_prod = Enum.filter(entregas_validas, &(&1.productor == productor.codigo))

      IO.puts("\n==========================================")
      IO.puts("        COMPROBANTE DE LIQUIDACION        ")
      IO.puts("==========================================")
      IO.puts("Productor: #{productor.nombre} (#{productor.codigo})")
      IO.puts("Servicio de Transporte: #{if productor.transporte, do: "SÍ", else: "NO"}")
      IO.puts("------------------------------------------")
      IO.puts("Detalle de entregas por día:")

      Enum.each(1..6, fn dia ->
        entregas_dia = Enum.filter(entregas_prod, &(&1.dia == dia))

        if entregas_dia != [] do
          litros_dia = Enum.sum(Enum.map(entregas_dia, & &1.litros))
          valor_dia = Enum.sum(Enum.map(entregas_dia, &valor_entrega/1))
          bonif_dia = if litros_dia >= @litros_bonificacion, do: @bonificacion_diaria, else: 0
          IO.puts("  Día #{dia}: Litros: #{litros_dia} L | Valor: $#{valor_dia} | Bonif: $#{bonif_dia}")
        end
      end)

      IO.puts("------------------------------------------")
      IO.puts("Total entregas (valor): $#{liq.valor_entregas}")
      IO.puts("Total bonificaciones:   $#{liq.bonificaciones}")
      IO.puts("Descuento transporte:  -$#{liq.transporte}")
      IO.puts("------------------------------------------")
      IO.puts("NETO A PAGAR:           $#{liq.neto}")
      IO.puts("==========================================\n")
    end
  end

  @doc """
  Combina los litros diarios de este centro con un centro vecino usando Map.merge/3.
  """
  def combinar_centros(litros_centro_actual, centro_vecino) do
    Map.merge(litros_centro_actual, centro_vecino, fn _dia, v1, v2 -> v1 + v2 end)
  end

  @doc """
Genera un ranking de los N productores con mayor pago neto usando Keyword Lists.
Las Keyword Lists son listas de tuplas de 2 elementos [{:átomo, valor}].
"""
def ranking(productores_liquidados, top_n) do
  productores_liquidados
  |> Enum.map(fn p -> {String.to_atom(p.codigo), p.neto} end)
  |> Enum.sort_by(fn {_cod, neto} -> neto end, :desc)
  |> Enum.take(top_n)
end
end
