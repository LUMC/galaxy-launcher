# Adapted from https://docs.docker.com/engine/examples/running_ssh_service/
# And from https://hub.docker.com/_/centos/ for information on how to enable systemd
FROM centos:7
ENV SSH_USER=galaxy_ssh

# SYSTEMD enable
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Disable no login policy
RUN rm -f usr/lib/tmpfiles.d/systemd-nologin.conf

# Install SSH python and sudo
RUN yum update -y && yum install -y openssh-server python sudo
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
ADD files/sshd_config /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Add host keys
RUN for type in rsa ecdsa ed25519 dsa ; do ssh-keygen -f "/etc/ssh/ssh_host_${type}_key" -N '' -t $type ; done
# Add passwordless sudo user.
RUN groupadd passwordless
RUN useradd -d /home/$SSH_USER -m -p $SSH_USER -G wheel,passwordless -s /bin/bash $SSH_USER
RUN echo "%passwordless         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers

USER $SSH_USER
RUN mkdir $HOME/.ssh
RUN chmod 700 $HOME/.ssh
ADD files/galaxy_ssh.pub /home/$SSH_USER/galaxy_ssh.pub
RUN cat $HOME/galaxy_ssh.pub >> $HOME/.ssh/authorized_keys
RUN chmod 600 $HOME/.ssh/authorized_keys


USER root

EXPOSE 22
RUN systemctl enable sshd.service
CMD ["/usr/sbin/init"]
#CMD ["/usr/sbin/sshd", "-D"]
