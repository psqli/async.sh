# Asynchronous promises for POSIX shell

Example:

```sh
. async.sh # include async.sh
promise=$(create_promise)
sleep 2 && echo Test | async $promise &
echo "Sleeping..."
echo "Result = $(await $promise)"
```

It's also possible to wait for all promises of a set to become ready (by using
`ready_all`), or for the first promise to be ready among the set (by using
`ready_any`). However, for both of these to work, it's necessary to build
`has_data.c`:

```sh
gcc -Wall -o has_data has_data.c
```

Example with `ready_any`:

```sh
. async.sh
promise_one=$(create_promise)
sleep 2 && echo One | async $promise_one &
promise_two=$(create_promise)
sleep 1 && echo Two | async $promise_two &
ready_promise=$(ready_any $promise_one $promise_two)
echo "Result = $(await $ready_promise)"
```

Example with `ready_any`:

TODO

# Testing

```sh
./test_async.sh
```
