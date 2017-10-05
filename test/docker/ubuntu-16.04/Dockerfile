# Adapted from https://docs.docker.com/engine/examples/running_ssh_service/
FROM ubuntu:16.04

ENV SSH_USER=galaxy_ssh

RUN apt-get update && apt-get install -y openssh-server python sudo
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
COPY files/sshd_config /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Add passwordless sudo user.
RUN groupadd passwordless
RUN useradd -d /home/$SSH_USER -m -p $SSH_USER -G sudo,passwordless -s /bin/bash $SSH_USER
RUN echo "%passwordless         ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $SSH_USER
RUN mkdir $HOME/.ssh
RUN chmod 700 $HOME/.ssh
COPY files/galaxy_ssh.pub /home/$SSH_USER/galaxy_ssh.pub
RUN cat $HOME/galaxy_ssh.pub >> $HOME/.ssh/authorized_keys
RUN chmod 600 $HOME/.ssh/authorized_keys




USER root

EXPOSE 8822
CMD ["/usr/sbin/sshd", "-D"]
