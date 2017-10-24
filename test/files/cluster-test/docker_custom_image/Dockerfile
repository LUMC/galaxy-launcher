# Adapts bgruening/galaxy-stable for use on a ogs-cluster

from bgruening/galaxy-stable:17.05

Maintainer test@example.com

USER root

run sed -i '3iecho "192.168.99.100 ogs-head" >> /etc/hosts' /usr/bin/startup


CMD ["/usr/bin/startup"]
