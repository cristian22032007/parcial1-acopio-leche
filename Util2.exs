#   Integrantes:
#       DELGADO CRUZ CRISTIAN FERNANDO,
#       LONDOÑO GOMEZ JUAN PABLO,
#       QUINTERO GIL JUAN CAMILO


defmodule Util2 do
  @moduledoc """
  Funciones auxiliares de propósito general para entrada y salida de datos,
  procesamiento de colecciones y conversión de sus elementos a texto.

  Esta versión está adaptada al parcial de Centro de Acopio de Leche.
  Se conservan las funciones de Util2 necesarias para el proyecto y se
  excluyen las funciones de ingreso que utilizan recursividad.
  """

  # -----------------------------------
  # Salida de datos
  # -----------------------------------

  @doc """
  Muestra un mensaje en la salida indicada.
  """
  def mostrar(mensaje, :mensaje), do: IO.puts(mensaje)
  def mostrar(mensaje, :error), do: IO.puts(:standard_error, mensaje)

  # -----------------------------------
  # Entrada de datos
  # -----------------------------------

  @doc """
  Lee una cadena de texto desde teclado.

  Esta función no realiza validaciones recursivas. Las validaciones
  específicas de las entregas se realizan posteriormente en Validacion.
  """
  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> caso_entrada()
  end

  defp caso_entrada(nil), do: ""
  defp caso_entrada(texto), do: String.trim(texto)

  # -----------------------------------
  # Operaciones sobre colecciones
  # -----------------------------------

  @doc """
  Ordena una colección utilizando Enum.sort_by/3.
  """
  def ordenar(coleccion, sentido \\ :asc, obtener_campo \\ & &1) do
    Enum.sort_by(coleccion, obtener_campo, sentido)
  end

  @doc """
  Filtra una colección de cadenas por longitud máxima.
  """
  def aplicar_filtro_longitud(coleccion, longitud) do
    aplicar_filtro(coleccion, &(String.length(&1) <= longitud))
  end

  @doc """
  Filtra una colección de cadenas por texto inicial.
  """
  def aplicar_filtro_inicial(coleccion, inicia) do
    aplicar_filtro(coleccion, &String.starts_with?(&1, inicia))
  end

  @doc """
  Filtra una colección utilizando una función de filtro.
  """
  def aplicar_filtro(coleccion, filtro) do
    Enum.filter(coleccion, filtro)
  end

  @doc """
  Convierte cada elemento de una colección a una representación textual.
  """
  def convertir_coleccion_mensaje(
        coleccion,
        formato \\ fn elemento -> " - #{elemento}\n" end
      ) do
    Enum.map(coleccion, formato)
  end
end
