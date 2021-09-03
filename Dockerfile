FROM ghcr.io/linuxserver/rdesktop:mate-focal
LABEL  maintainer = "Sporule <hao@sporule.com>"

# Install Basic Tools

RUN apt-get update && apt-get install -y ssh sudo wget procps gnupg curl software-properties-common sudo \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    nodejs \
    golang-go \
    python3 python-dev python3-dev python3-pip python3-venv\
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
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config



# Set up Airflow
RUN export AIRFLOW_HOME=/root/airflow \
	&& pip install apache-airflow

# Set up VSCode
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'\
    && rm -f packages.microsoft.gpg \
    && apt install -y apt-transport-https \
    && apt update \
    && apt install -y code

# Delete default user
RUN userdel abc

# Set up initial folder
WORKDIR /root

# Set up Configuration and Start Services
ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
