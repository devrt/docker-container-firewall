Limit port exposed from docker container to the public internet.

[![](https://images.microbadger.com/badges/image/devrt/container-firewall.svg)](https://microbadger.com/images/devrt/container-firewall "Get your own image badge on microbadger.com")

Background
----------

docker has a feature to isolate the container and listen to specific port exposed to the public internet.
However, we sometimes want to:
 - Expose utility port for administration access while limiting public access to the same port.
 - Enforce centralized policy to expose the port.

This utility docker image helps you to solve such problem.

Usage
-----

Enter following command to enforce the firewall:

```
$ docker run --name http-only-firewall --env ACCEPT_PORT="80,443" -itd --restart=always --cap-add=NET_ADMIN --net=host devrt/container-firewall
```

Check the output from the container:

```
$ docker logs http-only-firewall
```

Check your current iptables:

```
$ sudo iptables-save
```

You can confirm protection of the firewall by using nmap as well.

This firewall settings persist even after the reboot, when `--restart=always` option is set.

Notice
------

This firewall script uses DOCKER-USER iptables chain introduced in docker version 17.06 (version above is required).

Written by
----------

Yosuke Matsusaka <yosuke.matsusaka@gmail.com>

Distributed under MIT license.
