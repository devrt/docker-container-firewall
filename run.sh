#!/bin/sh

docker run --name http-only-firewall --env ACCEPT_PORT="80,443" -itd --restart=always --cap-add=NET_ADMIN --net=host devrt/container-firewall
