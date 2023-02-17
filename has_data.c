#include <poll.h>

int main() {
    struct pollfd fds = { 0, POLLIN, 0};
    poll(&fds, 1, -1);
    return fds.revents & POLLIN ? 0 : 1;
}
