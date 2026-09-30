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

# 1. Entrega adicional desde la consola
IO.puts("==========================================")
IO.puts("    REGISTRO DE ENTREGA ADICIONAL        ")
IO.puts("==========================================")
linea_adicional = IO.gets("Ingrese una entrega adicional (productor;tanque;dia;litros;grasa) o Enter para omitir: ")

todas_las_entregas =
  case Auxiliares.parsear_entrega_adicional(linea_adicional) do
    :omitir ->
      IO.puts("[i] No se ingreso entrega adicional. Continuando...")
      lista_entregas

    {:ok, entrega_nueva} ->
      case Validacion.validar_entrega(entrega_nueva, lista_productores, lista_tanques) do
        {:ok, _} ->
          IO.puts("[+] Entrega adicional valida incorporada al sistema.")
          lista_entregas ++ [entrega_nueva]

        {:error, motivo} ->
          IO.puts("[!] Entrega adicional rechazada por regla de negocio: #{motivo}")
          lista_entregas ++ [entrega_nueva]
      end

    {:error, :formato_invalido} ->
      IO.puts("[!] Error: formato invalido en la entrega adicional. Se omitira.")
      lista_entregas
  end

# 2. Filtrar entregas válidas para reportes y liquidación
entregas_validas =
  Enum.filter(todas_las_entregas, fn entrega ->
    case Validacion.validar_entrega(entrega, lista_productores, lista_tanques) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end)

# 3. Reportes R1 a R8
IO.puts("\n==========================================")
IO.puts("          REPORTE R1: RECHAZADAS          ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r1(todas_las_entregas, lista_productores, lista_tanques))

IO.puts("\n==========================================")
IO.puts("          REPORTE R2: TANQUES             ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r2(lista_tanques, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R3: METAS DIARIAS       ")
IO.puts("==========================================")
res_r3 = Reportes.reporte_r3(entregas_validas)
IO.inspect(res_r3)

IO.puts("\n==========================================")
IO.puts("          REPORTE R4: LIQUIDACION         ")
IO.puts("==========================================")
liquidaciones_r4 = Reportes.reporte_r4(lista_productores, entregas_validas)
IO.inspect(liquidaciones_r4)

IO.puts("\n==========================================")
IO.puts("          REPORTE R5: LIDERES DIARIOS     ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r5(lista_productores, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R6: MEJOR CALIDAD       ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r6(lista_productores, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R7: TOTAL PAGADO        ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r7(lista_productores, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R8: TODOS LOS TANQUES   ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r8(lista_productores, lista_tanques, entregas_validas))

# 4. Investigación Parte C: Map.merge/3, Keyword Lists y :timer.tc/1
IO.puts("\n==========================================")
IO.puts("     INVESTIGACION: Map.merge/3          ")
IO.puts("==========================================")
litros_actuales =
  res_r3.detalle_dias
  |> Enum.map(fn {dia, litros, _cumplio} -> {dia, litros} end)
  |> Enum.into(%{})

centro_vecino = %{1 => 1850.5, 2 => 2100, 3 => 1640, 5 => 2350, 7 => 800}

mapa_combinado = Auxiliares.combinar_centros(litros_actuales, centro_vecino)
IO.puts("Mapa de litros combinados con centro vecino:")
IO.inspect(mapa_combinado)

IO.puts("\n==========================================")
IO.puts("   RANKING CON KEYWORD LISTS   ")
IO.puts("==========================================")
top3_ranking = Auxiliares.ranking(liquidaciones_r4, 3)
IO.puts("Top 3 productores (formato Keyword List [{:productor, neto}]):")
IO.inspect(top3_ranking)

IO.puts("\n==========================================")
IO.puts("   MEDICION CON :timer.tc/1      ")
IO.puts("==========================================")
{tiempo_us, _resultado} = :timer.tc(fn -> Reportes.reporte_r4(lista_productores, entregas_validas) end)
IO.puts("Tiempo de ejecucion del Reporte R4 (Liquidacion): #{tiempo_us} microsegundos (#{tiempo_us / 1000} ms)")

# 5. Comprobante de Productor
IO.puts("\n==========================================")
IO.puts("      SOLICITUD DE COMPROBANTE            ")
IO.puts("==========================================")
codigo_ingresado =
  IO.gets("Ingrese el codigo del productor para ver comprobante (ej: P01): ")
  |> String.trim()

Auxiliares.imprimir_comprobante(codigo_ingresado, lista_productores, entregas_validas)
