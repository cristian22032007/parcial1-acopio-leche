#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("liquidacion.exs")
Code.require_file("reportes.exs")
Code.require_file("auxiliares.exs")

lista_productores = Datos.productores()
lista_tanques = Datos.tanques()
lista_entregas = Datos.entregas()


IO.puts("\n\n          REGISTRO DE ENTREGA ADICIONAL        ")
IO.puts("==========================================")
linea_adicional = IO.gets("Ingrese una entrega adicional (productor;tanque;dia;litros;grasa) o Enter para omitir: ")

todas_las_entregas =
  case Auxiliares.parsear_entrega_adicional(linea_adicional) do
    :omitir ->
      IO.puts("No se ingreso entrega adicional. Continuando...")
      lista_entregas

    {:ok, entrega_nueva} ->
      IO.puts("Entrega adicional recibida. Se validara junto con las demas.")
      lista_entregas ++ [entrega_nueva]

    {:error, :formato_invalido} ->
      IO.puts("Error: formato invalido en la entrega adicional. Se omitira.")
      lista_entregas
  end

resultados =
  Enum.map(todas_las_entregas, fn e ->
    {e, Validacion.validar_entrega(e, lista_productores, lista_tanques)}
  end)

entregas_validas = for {e, {:ok, _}} <- resultados, do: e
rechazadas = for {e, {:error, motivo}} <- resultados, do: {e, motivo}
liquidaciones = Liquidacion.liquidar_todos(entregas_validas, lista_productores)


IO.puts("\n\n          REPORTE R1: RECHAZADAS          ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r1(rechazadas))


IO.puts("\n\n          REPORTE R2: TANQUES             ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r2(lista_tanques, entregas_validas))


IO.puts("\n\n          REPORTE R3: METAS DIARIAS       ")
IO.puts("==========================================")
res_r3 = Reportes.reporte_r3(entregas_validas)
IO.inspect(res_r3)


IO.puts("\n\n          REPORTE R4: LIQUIDACION         ")
IO.puts("==========================================")
liquidaciones_r4 = Reportes.reporte_r4(liquidaciones)
IO.inspect(liquidaciones_r4)


IO.puts("\n\n          REPORTE R5: LIDERES DIARIOS     ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r5(lista_productores, entregas_validas))


IO.puts("\n\n          REPORTE R6: MEJOR CALIDAD       ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r6(lista_productores, entregas_validas))


IO.puts("\n\n          REPORTE R7: TOTAL PAGADO        ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r7(liquidaciones))


IO.puts("\n\n          REPORTE R8: TODOS LOS TANQUES   ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r8(lista_productores, lista_tanques, entregas_validas))


IO.puts("\n\n          INVESTIGACION: Map.merge/3          ")
IO.puts("==========================================")
litros_actuales =
  res_r3.detalle_dias
  |> Enum.map(fn {dia, litros, _cumplio} -> {dia, litros} end)
  |> Enum.into(%{})

centro_vecino = %{
  1 => 1850.5,
  2 => 2100,
  3 => 1640,
  5 => 2350,
  7 => 800
}

mapa_combinado = Auxiliares.combinar_centros(litros_actuales, centro_vecino)
IO.puts("Mapa de litros combinados con centro vecino:")
IO.inspect(mapa_combinado)


IO.puts("\n\n          RANKING CON KEYWORD LISTS   ")
IO.puts("==========================================")
top3_ranking = Auxiliares.ranking(liquidaciones_r4, 3)
IO.puts("Top 3 productores (formato Keyword List [{:productor, neto}]):")
IO.inspect(top3_ranking)


IO.puts("\n\n          MEDICION CON :timer.tc/1      ")
IO.puts("==========================================")
{tiempo_us, _resultado} =
  :timer.tc(fn -> Liquidacion.liquidar_todos(entregas_validas, lista_productores) end)

IO.puts("Tiempo de ejecucion de la liquidacion de todos los productores: #{tiempo_us} microsegundos (#{tiempo_us / 1000} ms)")


IO.puts("\n\n          SOLICITUD DE COMPROBANTE            ")
IO.puts("==========================================")
codigo_ingresado =
  (IO.gets("Ingrese el codigo del productor para ver comprobante (ej: P01): ") || "")
  |> String.trim()

Auxiliares.imprimir_comprobante(codigo_ingresado, lista_productores, entregas_validas)
