1. Create an openfortivpn configuration file named `config` like `config.template`.

    ```
    host = vpn.example.com
    port = 443
    username = foo
    password = bar
    ```

2. Run the following command to start the container.

    ```sh
    sudo docker build -t forti-i .
    sudo docker run -p 22332:22332 --cap-add=NET_ADMIN --device=/dev/ppp --name forti --rm forti-i
    ```

3. Now you can use SSL-VPN via `http://<container-ip>:22332` or `socks5://<container-ip>:22332`.

    ```
    $ http_proxy=http://172.17.0.2:22332 curl http://example.com

    $ ssh -o ProxyCommand="nc -x 172.17.0.2:22332 %h %p" foo@example.com
    ```
