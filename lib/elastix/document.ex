defmodule Elastix.Document do
  @moduledoc """
  """
  alias Elastix.HTTP

  @doc false
  def create(elastic_url, index_name, type_name, id, data, query_params \\ []) do
    elastic_url <> make_path(index_name, type_name, id, query_params, "_create")
    |> HTTP.put(Poison.encode!(data))
    |> process_response
  end

  @doc false
  def index(elastic_url, index_name, type_name, id, data) do
    index(elastic_url, index_name, type_name, id, data, [])
  end

  @doc false
  def index(elastic_url, index_name, type_name, id, data, query_params) do
    elastic_url <> make_path(index_name, type_name, id, query_params)
    |> HTTP.put(Poison.encode!(data))
    |> process_response
  end

  @doc false
  def index_new(elastic_url, index_name, type_name, data) do
    index_new(elastic_url, index_name, type_name, data, [])
  end

  @doc false
  def index_new(elastic_url, index_name, type_name, data, query_params) do
    elastic_url <> make_path(index_name, type_name, query_params)
    |> HTTP.post(Poison.encode!(data))
    |> process_response
  end

  @doc false
  def get(elastic_url, index_name, type_name, id) do
    get(elastic_url, index_name, type_name, id, [])
  end

  @doc false
  def get(elastic_url, index_name, type_name, id, query_params) do
    elastic_url <> make_path(index_name, type_name, id, query_params)
    |> HTTP.get
    |> process_response
  end

  @doc false
  def delete(elastic_url, index_name, type_name, id) do
    elastic_url <> make_path(index_name, type_name, id, [])
    |> HTTP.delete
    |> process_response
  end

  @doc false
  def delete(elastic_url, index_name, type_name, id, query_params) do
    elastic_url <> make_path(index_name, type_name, id, query_params)
    |> HTTP.delete
    |> process_response
  end

  @doc false
  def add_suffix(path, suffix) do
    case suffix do
      nil -> path
      _ -> "#{path}/#{suffix}"
    end
  end

  @doc false
  def make_path(index_name, type_name, id \\ nil, query_params, suffix \\ nil) do
    path = "/#{index_name}/#{type_name}/#{id}" |> add_suffix(suffix)

    case query_params do
      [] -> path
      _ -> add_query_params(path, query_params)
    end
  end

  @doc false
  defp add_query_params(path, query_params) do
    query_string = Enum.map_join query_params, "&", fn(param) ->
      "#{elem(param, 0)}=#{elem(param, 1)}"
    end

    "#{path}?#{query_string}"
  end

  @doc false
  defp process_response({_, response}), do: response
end
