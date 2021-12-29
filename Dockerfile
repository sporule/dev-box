FROM ubuntu:20.04
LABEL  maintainer = "Sporule <hao@sporule.com>"


# Install basic tools like wget
RUN apt-get update && apt-get install -y ssh wget procps gnupg curl software-properties-common


# Add basic repos
RUN  wget -O- https://apt.corretto.aws/corretto.key | apt-key add - \
     && add-apt-repository 'deb https://apt.corretto.aws stable main' \
     && curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Install Dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    java-1.8.0-amazon-corretto-jdk \
    nodejs \
    golang-go \
    python3 python-dev python3-dev python3-pip python3-venv\
    build-essential libssl-dev libffi-dev \
	libxml2-dev libxslt1-dev zlib1g-dev \
    neovim python3-neovim \
    git-all
	
# Set up SSH
COPY .ssh/ /root/.ssh/
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Set up Airflow
RUN export AIRFLOW_HOME=/root/airflow \
	&& pip install apache-airflow

# Set up initial folder
WORKDIR /root

# Set up Configuration and Start Services
ADD run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
