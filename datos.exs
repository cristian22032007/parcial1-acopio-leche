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
    %{codigo: "P04", nombre: "Danna nuñez", transporte: true},
    %{codigo: "P05", nombre: "Jorge Ospina", transporte: true},
    %{codigo: "P06", nombre: "Diana Marín", transporte: false},
    %{codigo: "P07", nombre: "Tatiana Heraldo", transporte: true},
    %{codigo: "P08", nombre: "Luciana Garzon", transporte: false},
    %{codigo: "P09", nombre: "Mojica roña", transporte: true},
    %{codigo: "P10", nombre: "Cristian Pacho", transporte: false}
  ]
end

  def tanques do
  [
    %{id: "T1", nombre: "Tanque Norte", capacidad: 5000},
    %{id: "T2", nombre: "Tanque Central", capacidad: 4000},
    %{id: "T3", nombre: "Tanque Sur", capacidad: 2800},
    %{id: "T4", nombre: "Tanque Oriente", capacidad: 3000},
    %{id: "T5", nombre: "Tanque Occidente", capacidad: 2500}
  ]
end

  def entregas do
  [
    # Día 1
    %{productor: "P01", tanque: "T1", dia: 1, litros: 240, grasa: 3.8},
    %{productor: "P01", tanque: "T2", dia: 1, litros: 230, grasa: 2.9},
    %{productor: "P02", tanque: "T1", dia: 1, litros: 180, grasa: 3.2},
    %{productor: "P03", tanque: "T3", dia: 1, litros: 150, grasa: 3.6},
    %{productor: "P04", tanque: "T1", dia: 1, litros: 210, grasa: 0.0},
    %{productor: "P05", tanque: "T2", dia: 1, litros: 160, grasa: 2.7},
    %{productor: "P06", tanque: "T4", dia: 1, litros: 140, grasa: 3.5},
    %{productor: "P07", tanque: "T3", dia: 1, litros: 220, grasa: 3.0},
    %{productor: "P08", tanque: "T2", dia: 1, litros: 120, grasa: 2.4},
    %{productor: "P09", tanque: "T1", dia: 1, litros: 190, grasa: 3.9},
    %{productor: "P02", tanque: "T3", dia: 1, litros: 90, grasa: 3.3},
    %{productor: "P06", tanque: "T1", dia: 1, litros: 110, grasa: 2.6},
    %{productor: "P04", tanque: "T4", dia: 1, litros: 130, grasa: 3.4},

    # Día 2
    %{productor: "P03", tanque: "T1", dia: 2, litros: 200, grasa: 3},
    %{productor: "P03", tanque: "T2", dia: 2, litros: 150, grasa: 3.3},
    %{productor: "P03", tanque: "T3", dia: 2, litros: 120, grasa: 2.8},
    %{productor: "P01", tanque: "T1", dia: 2, litros: 180, grasa: 3.6},
    %{productor: "P02", tanque: "T2", dia: 2, litros: 140, grasa: 3},
    %{productor: "P04", tanque: "T3", dia: 2, litros: 170, grasa: 3.5},
    %{productor: "P05", tanque: "T4", dia: 2, litros: 210, grasa: 3.2},
    %{productor: "P06", tanque: "T2", dia: 2, litros: 100, grasa: 5},
    %{productor: "P07", tanque: "T1", dia: 2, litros: 180, grasa: 3.8},
    %{productor: "P09", tanque: "T3", dia: 2, litros: 110, grasa: 2.3},
    %{productor: "P09", tanque: "T2", dia: 2, litros: 90, grasa: 3.4},
    %{productor: "P04", tanque: "T2", dia: 2, litros: 130, grasa: 3.1},
    %{productor: "P05", tanque: "T5", dia: 2, litros: 100, grasa: 3.0},
    %{productor: "P07", tanque: "T4", dia: 2, litros: 60, grasa: 3.6},

    # Día 3
    %{productor: "P02", tanque: "T1", dia: 3, litros: 700, grasa: 15},
    %{productor: "P01", tanque: "T1", dia: 3, litros: 200, grasa: 3.5},
    %{productor: "P03", tanque: "T2", dia: 3, litros: 140, grasa: 3.4},
    %{productor: "P04", tanque: "T5", dia: 3, litros: 160, grasa: 3.2},
    %{productor: "P05", tanque: "T3", dia: 3, litros: 180, grasa: 2.6},
    %{productor: "P06", tanque: "T3", dia: 3, litros: 150, grasa: 3.6},
    %{productor: "P07", tanque: "T2", dia: 3, litros: 120, grasa: 3.1},
    %{productor: "P07", tanque: "T4", dia: 3, litros: 90, grasa: 2.8},
    %{productor: "P09", tanque: "T4", dia: 3, litros: 210, grasa: 3.3},
    %{productor: "P01", tanque: "T3", dia: 3, litros: 100, grasa: 3.7},
    %{productor: "P03", tanque: "T4", dia: 3, litros: 80, grasa: 2.5},
    %{productor: "P05", tanque: "T1", dia: 3, litros: 130, grasa: 3.0},
    %{productor: "P06", tanque: "T5", dia: 3, litros: 90, grasa: 3.8},

    # Día 4
    %{productor: "P01", tanque: "T2", dia: 4, litros: 150, grasa: 3.6},
    %{productor: "P02", tanque: "T2", dia: 4, litros: 50, grasa: 6.0},
    %{productor: "P03", tanque: "T1", dia: 4, litros: 250, grasa: 3.2},
    %{productor: "P04", tanque: "T1", dia: 4, litros: 190, grasa: 3.0},
    %{productor: "P05", tanque: "T5", dia: 4, litros: 100, grasa: 2.9},
    %{productor: "P06", tanque: "T2", dia: 4, litros: 130, grasa: 3.3},
    %{productor: "P07", tanque: "T3", dia: 4, litros: 140, grasa: 3.5},
    %{productor: "P09", tanque: "T2", dia: 4, litros: 110, grasa: 3.7},
    %{productor: "P01", tanque: "T4", dia: 4, litros: 90, grasa: 2.7},
    %{productor: "P03", tanque: "T4", dia: 4, litros: 60, grasa: 3.1},
    %{productor: "P04", tanque: "T2", dia: 4, litros: 80, grasa: 3.4},
    %{productor: "P05", tanque: "T4", dia: 4, litros: 120, grasa: 3.0},
    %{productor: "P06", tanque: "T4", dia: 4, litros: 70, grasa: 2.4},
    %{productor: "P08", tanque: "T1", dia: 4, litros: 100, grasa: 3.0},

    # Día 5
    %{productor: "P02", tanque: "T3", dia: 5, litros: 50, grasa: 6.0},
    %{productor: "P01", tanque: "T3", dia: 5, litros: 130, grasa: 3.8},
    %{productor: "P03", tanque: "T1", dia: 5, litros: 250, grasa: 3.5},
    %{productor: "P04", tanque: "T3", dia: 5, litros: 200, grasa: 3.2},
    %{productor: "P05", tanque: "T1", dia: 5, litros: 300, grasa: 3.6},
    %{productor: "P05", tanque: "T2", dia: 5, litros: 180, grasa: 3.3},
    %{productor: "P06", tanque: "T1", dia: 5, litros: 160, grasa: 2.8},
    %{productor: "P07", tanque: "T2", dia: 5, litros: 210, grasa: 3.0},
    %{productor: "P09", tanque: "T4", dia: 5, litros: 170, grasa: 3.4},
    %{productor: "P07", tanque: "T2", dia: 5, litros: 90, grasa: 3.1},
    %{productor: "P06", tanque: "T3", dia: 5, litros: 120, grasa: 3.6},
    %{productor: "P09", tanque: "T3", dia: 5, litros: 140, grasa: 2.9},
    %{productor: "P04", tanque: "T4", dia: 5, litros: 150, grasa: 3.7},

    # Día 6
    %{productor: "P07", tanque: "T1", dia: 6, litros: 250, grasa: 3.5},
    %{productor: "P07", tanque: "T3", dia: 6, litros: 150, grasa: 3.2},
    %{productor: "P09", tanque: "T5", dia: 6, litros: 200, grasa: 3.6},
    %{productor: "P09", tanque: "T2", dia: 6, litros: 200, grasa: 3.0},
    %{productor: "P01", tanque: "T3", dia: 6, litros: 180, grasa: 3.4},
    %{productor: "P02", tanque: "T4", dia: 6, litros: 120, grasa: 3.1},
    %{productor: "P03", tanque: "T2", dia: 6, litros: 220, grasa: 3.7},
    %{productor: "P04", tanque: "T2", dia: 6, litros: 140, grasa: 3.3},
    %{productor: "P05", tanque: "T4", dia: 6, litros: 160, grasa: 2.8},
    %{productor: "P06", tanque: "T5", dia: 6, litros: 110, grasa: 3.5},
    %{productor: "P01", tanque: "T1", dia: 6, litros: 90, grasa: 3.0},
    %{productor: "P03", tanque: "T3", dia: 6, litros: 100, grasa: 3.2},
    %{productor: "P04", tanque: "T5", dia: 6, litros: 80, grasa: 3.6},

    # ---------- Entregas inválidas ----------

    # :productor_desconocido
    %{productor: "P99", tanque: "T1", dia: 2, litros: 150, grasa: 3.2},
    %{productor: "P77", tanque: "T9", dia: 9, litros: -5, grasa: 20},

    # :tanque_desconocido
    %{productor: "P03", tanque: "T9", dia: 3, litros: 180, grasa: 3.1},
    %{productor: "P05", tanque: "T0", dia: 0, litros: 300, grasa: 3.4},

    # :dia_invalido
    %{productor: "P04", tanque: "T2", dia: 7, litros: 120, grasa: 3.3},
    %{productor: "P06", tanque: "T1", dia: 2.5, litros: 140, grasa: 3.0},

    # :litros_fuera_de_rango
    %{productor: "P07", tanque: "T3", dia: 4, litros: 0, grasa: 3.5},
    %{productor: "P09", tanque: "T4", dia: 5, litros: 800.1, grasa: 3.6},

    # :porcentaje_invalido
    %{productor: "P01", tanque: "T2", dia: 3, litros: 160, grasa: 15.1},
    %{productor: "P02", tanque: "T1", dia: 6, litros: 100, grasa: -0.1}
  ]
end
end
