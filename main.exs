#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

Code.require_file("Util2.exs")
Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("liquidacion.exs")
Code.require_file("reportes.exs")
Code.require_file("auxiliares.exs")

lista_productores = Datos.productores()
lista_tanques = Datos.tanques()
lista_entregas = Datos.entregas()


Util2.mostrar("\n\n          REGISTRO DE ENTREGA ADICIONAL        ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
linea_adicional =
  Util2.ingresar(
    "Ingrese una entrega adicional (productor;tanque;dia;litros;grasa) o Enter para omitir: ",
    :texto
  )
todas_las_entregas =
  case Auxiliares.parsear_entrega_adicional(linea_adicional) do
    :omitir ->
      Util2.mostrar("[i] No se ingreso entrega adicional. Continuando...", :mensaje)
      lista_entregas

    {:ok, entrega_nueva} ->
      Util2.mostrar("[i] Entrega adicional recibida. Se validara junto con las demas.", :mensaje)
      lista_entregas ++ [entrega_nueva]

    {:error, :formato_invalido} ->
      Util2.mostrar("[!] Error: formato invalido en la entrega adicional. Se omitira.", :error)
      lista_entregas
  end

resultados =
  Enum.map(todas_las_entregas, fn e ->
    {e, Validacion.validar_entrega(e, lista_productores, lista_tanques)}
  end)

entregas_validas = for {e, {:ok, _}} <- resultados, do: e
rechazadas = for {e, {:error, motivo}} <- resultados, do: {e, motivo}
liquidaciones = Liquidacion.liquidar_todos(entregas_validas, lista_productores)


Util2.mostrar("\n\n          REPORTE R1: RECHAZADAS          ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
IO.inspect(Reportes.reporte_r1(rechazadas))


Util2.mostrar("\n\n          REPORTE R2: TANQUES             ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
IO.inspect(Reportes.reporte_r2(lista_tanques, entregas_validas))


Util2.mostrar("\n\n          REPORTE R3: METAS DIARIAS       ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
res_r3 = Reportes.reporte_r3(entregas_validas)
IO.inspect(res_r3)


Util2.mostrar("\n\n          REPORTE R4: LIQUIDACION         ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
liquidaciones_r4 = Reportes.reporte_r4(liquidaciones)
IO.inspect(liquidaciones_r4)


Util2.mostrar("\n\n          REPORTE R5: LIDERES DIARIOS     ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
IO.inspect(Reportes.reporte_r5(lista_productores, entregas_validas))


Util2.mostrar("\n\n          REPORTE R6: MEJOR CALIDAD       ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
IO.inspect(Reportes.reporte_r6(lista_productores, entregas_validas))


Util2.mostrar("\n\n          REPORTE R7: TOTAL PAGADO        ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
IO.inspect(Reportes.reporte_r7(liquidaciones))


Util2.mostrar("\n\n          REPORTE R8: TODOS LOS TANQUES   ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
IO.inspect(Reportes.reporte_r8(lista_productores, lista_tanques, entregas_validas))


Util2.mostrar("\n\n          INVESTIGACION: Map.merge/3          ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
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
Util2.mostrar("Mapa de litros combinados con centro vecino:", :mensaje)
IO.inspect(mapa_combinado)


Util2.mostrar("\n\n          RANKING CON KEYWORD LISTS   ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
top3_ranking = Auxiliares.ranking(liquidaciones_r4, 3)
Util2.mostrar("Top 3 productores (formato Keyword List [{:productor, neto}]):", :mensaje)
IO.inspect(top3_ranking)


Util2.mostrar("\n\n          MEDICION CON :timer.tc/1      ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
{tiempo_us, _resultado} =
  :timer.tc(fn -> Liquidacion.liquidar_todos(entregas_validas, lista_productores) end)

Util2.mostrar(
  "Tiempo de ejecucion de la liquidacion de todos los productores:
#{tiempo_us} microsegundos (#{tiempo_us / 1000} ms)",
  :mensaje
)


Util2.mostrar("\n\n          SOLICITUD DE COMPROBANTE            ", :mensaje)
Util2.mostrar("==========================================", :mensaje)
codigo_ingresado =
  Util2.ingresar("Ingrese el codigo del productor para ver comprobante (ej: P01): ", :texto)

Auxiliares.imprimir_comprobante(codigo_ingresado, lista_productores, entregas_validas)