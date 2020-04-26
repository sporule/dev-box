FROM ubuntu:18.04


LABEL  maintainer = "Sporule <hao@sporule.com>"

# Install Basic Tools

RUN apt-get update && apt-get install -y ssh wget procps gnupg curl software-properties-common


# Add Source

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN add-apt-repository ppa:longsleep/golang-backports
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list


# Install Tools and Build Dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    nodejs \
    golang-go \
    python3 python-dev python3-dev python-pip\
    build-essential libssl-dev libffi-dev \
	libxml2-dev libxslt1-dev zlib1g-dev \
    neovim python3-neovim \
    git-all

# Set up SSH
COPY .ssh/ /root/.ssh/
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Set up initial folder
WORKDIR /root

# Set up Configuration and Start Services
ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
