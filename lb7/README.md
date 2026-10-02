### Proxy Load Balancer

- No Proxy LB ao acessar os logs do Nginx em /var/log/nginx/access.log aparece um IP da subnet proxy-only e não o IP do cliente que acesso o LB, ou seja, o LB termina a conexão TCP/HTTP e abre outra conexão com o backend. O backend não conversa diretamente com o cliente.

- Outra característica do LB Proxy é que ele pode tomar decisões L7 como roteamento baseado no path, host ou HTTP headers.