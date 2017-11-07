# Adapts bgruening/galaxy-stable for use on a ogs-cluster

from bgruening/galaxy-stable:17.09

Maintainer test@example.com

USER root

# Makes sure the host knows the IP of the cluster head node
run sed -i '3iecho "10.0.1.100 head-node" >> /etc/hosts' /usr/bin/startup


CMD ["/usr/bin/startup"]
