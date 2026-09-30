#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("liquidacion.exs")
Code.require_file("reportes.exs")

lista_productores = Datos.productores()
lista_tanques = Datos.tanques()
lista_entregas = Datos.entregas()

entregas_validas =
  Enum.filter(lista_entregas, fn entrega ->
    case Validacion.validar_entrega(entrega, lista_productores, lista_tanques) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end)

IO.puts("\n==========================================")
IO.puts("          REPORTE R1: RECHAZADAS          ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r1(lista_entregas, lista_productores, lista_tanques))

IO.puts("\n==========================================")
IO.puts("          REPORTE R2: TANQUES             ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r2(lista_tanques, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R3: METAS DIARIAS       ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r3(entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R4: LIQUIDACION         ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r4(lista_productores, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R5: CONSTANCIA          ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r5(lista_productores, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R6: PROMEDIO GRASA      ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r6(lista_productores, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R7: PORCENTAJE LECHE    ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r7(lista_productores, entregas_validas))

IO.puts("\n==========================================")
IO.puts("          REPORTE R8: DIA MAYOR INGRESO   ")
IO.puts("==========================================")
IO.inspect(Reportes.reporte_r8(entregas_validas))
