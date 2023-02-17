#!/bin/sh

. ./async.sh # Include async.sh

my_async_function() {
    sleep 2
    echo "Ready"
}

promise=$(create_promise)
my_async_function | async $promise &

echo "Promise is running in the background"
echo "$(await $promise)"
