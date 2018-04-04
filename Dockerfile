FROM phusion/baseimage
MAINTAINER MarkusMcNugen

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server fail2ban && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint /
RUN chmod +x /entrypoint

EXPOSE 22

ENTRYPOINT ["/entrypoint"]

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
