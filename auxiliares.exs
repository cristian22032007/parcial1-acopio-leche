#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

defmodule Auxiliares do
  @moduledoc """
  Funciones de apoyo del programa: lectura de la entrega adicional,
  comprobante del productor y ejercicios de la investigación
  (Map.merge/3 y ranking con keyword lists).

  No contiene reglas de negocio: el valor de las entregas, las
  bonificaciones y el transporte se calculan solo en `Liquidacion`.
  """

  # Entrada adicional (pura: recibe texto y devuelve datos)

  @doc """
  Convierte el texto de una entrega adicional en un mapa.

  Formato esperado: `productor;tanque;dia;litros;grasa`.

  Devuelve `:omitir` si la línea está vacía (o es `nil`),
  `{:ok, entrega}` si el formato es correcto, y
  `{:error, :formato_invalido}` si no hay exactamente cinco campos, si el
  día no es un entero limpio o si litros o grasa no son numéricos.
  """
  def parsear_entrega_adicional(nil), do: :omitir

  def parsear_entrega_adicional(linea) do
    linea_limpia = String.trim(linea)

    if linea_limpia == "" do
      :omitir
    else
      campos = linea_limpia |> String.split(";") |> Enum.map(&String.trim/1)

      case campos do
        [productor, tanque, dia_txt, litros_txt, grasa_txt] ->
          with {dia, ""} <- Integer.parse(dia_txt),
               {litros, ""} <- Float.parse(litros_txt),
               {grasa, ""} <- Float.parse(grasa_txt) do
            {:ok, %{productor: productor, tanque: tanque, dia: dia, litros: litros, grasa: grasa}}
          else
            _ -> {:error, :formato_invalido}
          end

        _ ->
          {:error, :formato_invalido}
      end
    end
  end

  # Comprobante (impura: imprime en pantalla)

  @doc """
  Imprime el comprobante semanal de un productor según su código.

  Si el código no existe, lo indica sin fallar. Los valores salen de
  `Liquidacion`, así que coinciden siempre con los de R4.
  """
  def imprimir_comprobante(codigo, productores, entregas_validas) do
    case Enum.find(productores, fn p -> p.codigo == codigo end) do
      nil ->
        IO.puts("\n[!] El código de productor '#{codigo}' no existe.")

      productor ->
        entregas_productor = Enum.filter(entregas_validas, fn e -> e.productor == productor.codigo end)
        liquidacion = Liquidacion.liquidar_productor(entregas_validas, productor)
        detalle = Liquidacion.detalle_por_dia(entregas_productor)

        IO.puts("        COMPROBANTE DE LIQUIDACION        ")
        IO.puts("==========================================")
        IO.puts("Productor: #{productor.nombre} (#{productor.codigo})")
        IO.puts("------------------------------------------")
        IO.puts("Detalle de entregas por día:")

        if detalle == [] do
          IO.puts("  Sin entregas válidas.")
        else
          Enum.each(detalle, fn d ->
            IO.puts(
              "  Día #{d.dia}: #{d.litros} L | Valor: $#{redondear(d.valor)} | Bonificación: $#{redondear(d.bonificacion)}"
            )
          end)
        end

        IO.puts("------------------------------------------")
        IO.puts("Total entregas (valor): $#{redondear(liquidacion.valor_entregas)}")
        IO.puts("Total bonificaciones:   $#{redondear(liquidacion.bonificaciones)}")
        IO.puts("Descuento transporte:  -$#{redondear(liquidacion.transporte)}")
        IO.puts("------------------------------------------")
        IO.puts("NETO A PAGAR:           $#{redondear(liquidacion.neto)}")
        IO.puts("==========================================\n")
    end
  end

  # Investigación (puras)

  @doc """
  Combina los litros diarios de este centro con los de un centro vecino.

  Usa `Map.merge/3`: si un día aparece en ambos mapas se suman los valores;
  si aparece en uno solo, se conserva tal cual.
  """
  def combinar_centros(litros_centro_actual, centro_vecino) do
    Map.merge(litros_centro_actual, centro_vecino, fn _dia, litros_a, litros_b -> litros_a + litros_b end)
  end

  @doc """
  Genera el ranking de los `top_n` productores con mayor pago neto.

  Devuelve una keyword list `[{:P01, neto}, ...]` ordenada de mayor a menor.
  """
  def ranking(liquidaciones, top_n) do
    liquidaciones
    |> Enum.map(fn l -> {String.to_atom(l.codigo), l.neto} end)
    |> Enum.sort_by(fn {_codigo, neto} -> neto end, :desc)
    |> Enum.take(top_n)
  end

  # Privadas

  # Redondea a 2 decimales para que el comprobante sea legible.
  defp redondear(numero), do: Float.round(numero / 1, 2)
end
