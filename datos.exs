#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO


defmodule Datos do
  def productores do
  [
    %{codigo: "P01", nombre: "Marta Gómez", transporte: true},
    %{codigo: "P02", nombre: "Luis Cardona", transporte: false},
    %{codigo: "P03", nombre: "Carlos Ramírez", transporte: true},
    %{codigo: "P04", nombre: "Ana Restrepo", transporte: true},
    %{codigo: "P05", nombre: "Jorge Ospina", transporte: true},
    %{codigo: "P06", nombre: "Diana Marín", transporte: false},
    %{codigo: "P07", nombre: "Hernán Giraldo", transporte: true},
    %{codigo: "P08", nombre: "Luz Marina Quintero", transporte: false},
    %{codigo: "P09", nombre: "Andrés Botero", transporte: true},
    %{codigo: "P10", nombre: "Sandra Patiño", transporte: false}
  ]
end

  def tanques do
  [
    %{id: "T1", nombre: "Tanque Norte", capacidad: 5000},
    %{id: "T2", nombre: "Tanque Central", capacidad: 4000},
    %{id: "T3", nombre: "Tanque Sur", capacidad: 3500},
    %{id: "T4", nombre: "Tanque Oriente", capacidad: 3000},
    %{id: "T5", nombre: "Tanque Occidente", capacidad: 2500}
  ]
end

  def entregas do
    [
      %{productor: "P01", tanque: "T1", dia: 1, litros: 240, grasa: 3.8},
      %{productor: "P01", tanque: "T2", dia: 1, litros: 230, grasa: 2.9}

    ]
  end
end
