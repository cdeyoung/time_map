# Challenge

Write an in-memory, key/value store that accumulates a series of values for any given key and allows you to go back in time and see what the value of a key was at any given point in time.

## Basic Operations

Write code to get and set values for any specified key.  In Ruby, your code might look something like this:

    kv = KV.new
    kv.set('foo', 'bar')
    => 2018–07–02 18:20:13 –0600
    kv.get('foo')
    => "bar"

## Intermediate Operations

Write code to set the value for a specified key and include the ability to see what a key's value was set to at a specific point in time.  In Ruby, your code might look something like this:

    kv = KV.new
    timestamp_1 = kv.set('foo', 'bar')
    sleep(1)
    timestamp_2 = kv.set('foo', 'baz')

**timestamp_1** should equal something like **2018-07-02 18:20:13 -0600** and **timestamp_2** should be one second later, **2018-07-02 18:20:14 -0600**.

Next, write code that gets the value for a key at a specific time.  Your code should accept an optional timestamp parameter.  If the parameter exists, the code should return the value that was saved at that precise time, like this:

    kv.get('foo', 2018-07-02 18:20:13 -0600)
    => "bar"

If the timestamp parameter is excluded, the code should return the most recent value stored, like this:

    kv.get('foo')
    => "baz"


## Advanced Operations

Add support for fuzzy matching on a timestamp.  If the timestamp parameter is present, your code should either return the value that exactly matches the timestamp or return the closest value to that timestamp in the past.  In Ruby, your code might look something like this:

    kv = KV.new
    kv.set('foo', 'bar')
    => 2018-07-02 18:20:13 -0600

    sleep(3)

    kv.set('foo', 'baz')
    => 2018-07-02 18:20:16 -0600

    kv.get('foo', 2018-07-02 18:20:15 -0600
    => "bar"

