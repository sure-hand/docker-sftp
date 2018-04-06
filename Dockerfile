FROM phusion/baseimage

MAINTAINER MarkusMcNugen
# Forked from atmoz for unRAID

VOLUME /config

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server fail2ban rsync && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY entrypoint /
RUN chmod +x /entrypoint && \
    mkdir -p /config/fail2ban && \
    mkdir -p /config/sshd && \
    mkdir -p /etc/default/sshd && \
    mkdir -p /etc/default/f2ban

ADD fail2ban /etc/default/f2ban
ADD sshd /etc/default/sshd

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
