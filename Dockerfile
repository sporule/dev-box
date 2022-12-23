FROM ghcr.io/linuxserver/rdesktop:ubuntu-xfce
LABEL  maintainer = "Sporule <hao@sporule.com>"



# Install basic tools like wget
RUN apt update && apt install -y ssh wget gpg procps gnupg curl software-properties-common sudo

# Add repos
RUN  wget -O- https://apt.corretto.aws/corretto.key | apt-key add - \
     && add-apt-repository 'deb https://apt.corretto.aws stable main' \
     && add-apt-repository ppa:cwchien/gradle -y \
     && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
     && wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
     && sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
     && sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'\
     && rm -f packages.microsoft.gpg \
     && apt install apt-transport-https

# Install tools and dependencies
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -yq \
    java-17-amazon-corretto-jdk gradle \
    nodejs \
    golang-go \
    python3 python3-dev python3-pip python3-venv\
    build-essential libssl-dev libffi-dev \
	libxml2-dev libxslt1-dev zlib1g-dev \
    neovim \
    git-all \
    code \
    fonts-droid-fallback ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming


# Clean Package Management Archive

RUN apt clean && \
	rm -rf /var/lib/apt/lists/*

# Enable SSH Password Auth
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config


# Delete default user abc
RUN userdel abc

# Set up Configuration and Start Services
ADD run.sh /run.sh
RUN chmod a+x /run.sh
ENTRYPOINT ["/usr/bin/env"]
CMD ["/run.sh"]
