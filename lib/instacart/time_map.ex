defmodule Instacart.TimeMap do
  @moduledoc """
  In memory map that supports time-travel
  """

  @doc """
  Get the latest value stored for the specified "key" in the TimeMap
  """
  def get(key) when is_binary(key), do: String.to_atom(key) |> get()

  def get(key) when is_atom(key) do
    _last(key)
  end

  @doc """
  Get the value for "key" at the specified timestamp ("ts").  If there is no value
  at the specified timestamp, return the closest value before the current timestamp
  """
  def get(key, ts) when is_binary(key), do: String.to_atom(key) |> get(ts)

  def get(key, ts) when is_atom(key) do
    :ets.lookup(key, ts)
    |> case do
      [] ->
        _fuzzy_get(key, ts)
      _ ->
        :ets.lookup_element(key, ts, 2)
    end
  end

  @doc """
  Create a new key in the TimeMap
  """
  def new(key) when is_binary(key), do: String.to_atom(key) |> new()

  def new(key) when is_atom(key) do
    :ets.new(key, [:ordered_set, :protected, :named_table])
  end

  @doc """
  Set a "value" for the specified "key" in the TimeMap
  """
  def set(key, value) when is_binary(key), do: String.to_atom(key) |> set(value)

  def set(key, value) when is_atom(key) do
    now = DateTime.utc_now
    :ets.insert_new(key, {now, value})
    now
  end

  # Private functions
  defp _first(key) when is_atom(key) do
    ts = :ets.first(key)
    :ets.lookup_element(key, ts, 1)
  end

  defp _fuzzy_get(key, ts) do
    stored_ts = _first(key)
    _fuzzy_get(key, ts, stored_ts, stored_ts)
  end

  defp _fuzzy_get(key, _, current_ts, _) when current_ts == :"$end_of_table" do
    get(key)
  end

  defp _fuzzy_get(key, ts, current_ts, _last_ts) when ts > current_ts do
    _fuzzy_get(key, ts, :ets.next(key, current_ts), current_ts)
  end

  defp _fuzzy_get(key, ts, current_ts, last_ts) when ts < current_ts do
    get(key, last_ts)
  end

  defp _last(key) when is_atom(key) do
    ts = :ets.last(key)
    :ets.lookup_element(key, ts, 2)
  end
end
