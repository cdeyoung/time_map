defmodule Instacart.TimeMapTest do
  use ExUnit.Case

  alias Instacart.TimeMap

  setup do
    TimeMap.new("foo")
    :ok
  end

  test "the foo table exists" do
    assert :ets.info(:foo) != :undefined
  end

  test "set the value of 'foo' to 'bar,' wait 3 seconds, and then set the value to 'baz'" do
    TimeMap.set("foo", "bar")
    assert TimeMap.get("foo") == "bar"
    :timer.sleep(3)
    TimeMap.set("foo", "baz")
    assert TimeMap.get("foo") == "baz"
  end

  test "set the value of 'foo' to 'fob,' wait 3 seconds, and then set the value to 'fib.' Then, use a timestamp to get the value 'fob'" do
    ts = TimeMap.set("foo", "fob")
    assert TimeMap.get("foo") == "fob"
    :timer.sleep(3)
    TimeMap.set("foo", "fib")
    assert TimeMap.get("foo") == "fib"
    assert TimeMap.get("foo", ts) == "fob"
  end

  test "test the time-travel capabilities of TimeMap" do
    ding_ts = TimeMap.set("foo", "ding")
    shifted_ding_ts = Timex.shift(ding_ts, seconds: 2)
    :timer.sleep(3)

    dang_ts = TimeMap.set("foo", "dang")
    shifted_dang_ts = Timex.shift(dang_ts, seconds: 2)
    :timer.sleep(3)

    dong_ts = TimeMap.set("foo", "dong")
    shifted_dong_ts = Timex.shift(dong_ts, seconds: 2)

    before_all_ts = Timex.shift(ding_ts, months: -6)

    assert TimeMap.get("foo", shifted_ding_ts) == "ding"
    assert TimeMap.get("foo", shifted_dang_ts) == "dang"
    assert TimeMap.get("foo", shifted_dong_ts) == "dong"
    :timer.sleep(3)
    assert TimeMap.get("foo", Timex.now) == "dong"
    assert TimeMap.get("foo", before_all_ts) == "ding"
  end
end
