FROM ubuntu:20.10
LABEL  maintainer = "Sporule <hao@sporule.com>"

# Install Basic Tools

RUN apt-get update && apt-get install -y ssh wget procps gnupg curl software-properties-common

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Install Tools and Build Dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    nodejs \
    golang-go \
    python3 python-dev python3-dev python-pip python3-venv\
    build-essential libssl-dev libffi-dev \
	libxml2-dev libxslt1-dev zlib1g-dev \
    neovim python3-neovim \
    git-all

# Set up Jupyter Hub

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
	&& pip install jupyterhub notebook findspark\
	&& npm install -g configurable-http-proxy \
	&& yes | jupyterhub --generate-config \
	&& echo "c.LocalProcessSpawner.shell_cmd = ['bash', '-l', '-c']" >> "/root/jupyterhub_config.py"

# Set up SSH
COPY .ssh/ /root/.ssh/
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Set up initial folder
WORKDIR /root

# Set up Configuration and Start Services
ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
