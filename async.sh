#!/bin/sh
#
# WARNING: By launching more than one asynchronous task with the same
# promise, the results will be mixed together (causing a race condition).

# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/mkfifo.html

ASYNC_FIFO_PATH="${TMPDIR:-/tmp}/async_fifo_$$_"

get_promise_path() { printf "${ASYNC_FIFO_PATH}$1"; }
create_promise() {
	ASYNC_CURRENT_ID=0
	while [ -p $(get_promise_path $ASYNC_CURRENT_ID) ]; do
		ASYNC_CURRENT_ID=$((ASYNC_CURRENT_ID+1))
	done
	printf $ASYNC_CURRENT_ID
	mkfifo $(get_promise_path $ASYNC_CURRENT_ID)
}
# Create FIFO and start the redirector (which is the cat utility)
async() { cat >$(get_promise_path $1); }
# Wait for data and remove the FIFO file
await() { cat <$(get_promise_path $1); rm $(get_promise_path $1); }

ready_any() {} # TODO: use has_data
ready_all() {} # TODO: use has_data

# Tests
# ==============================================================================

test_promise_simple() {
	promise=$(create_promise)
	sleep 2 && echo Test | async $promise &
	printf "Promise $promise started\n"
	result=$(await $promise)
	printf "Promise $promise awaited. Result = $result\n"
}
test_promise_empty() {
	promise=$(create_promise)
	async $promise &
	echo "Result = '$(await $promise)'"
}
test_promise_array() {
	for val in 1 2 3 4 5; do
		promise=$(create_promise)
		sleep $val && printf $val | async $promise &
	done
	echo "All promises running"
	i=0; while [ $i -le $promise ]; do
		echo $(await $i)
		i=$((i+1))
	done
}
while [ ! -z "${1#test_promise_}" ]; do $1; shift; done
