#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO

Code.require_file("datos.exs")
Code.require_file("validacion.exs")

 entrega = %{
   productor: "P01",
   tanque: "T1",
   día: 1,
   litros: 240,
   grasa: 3.8
 }

  IO.inspect(
    Validacion.validar_entrega(
      entrega,
      Datos.productores(),
      Datos.tanques()
    )
  )
