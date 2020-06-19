FROM ubuntu:18.04

LABEL maintainer="joe.terlecki@devinitly.com"
LABEL version="1.0"
LABEL description="This docker image is containerizes a gitlab terraform runner on ubuntu for ecs"

RUN apt update && apt upgrade -y && apt install unzip wget git -y && apt-get clean && rm -rf /var/lib/apt/lists/ \
    && wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip \
    && unzip terraform_0* && mv terraform /usr/local/bin/terraform && rm terraform*.zip \
    && wget -O /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.23.26/terragrunt_linux_amd64 \
    && chmod +x /usr/local/bin/terragrunt \
    && wget -O /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 \
    && chmod +x /usr/local/bin/gitlab-runner && useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash \
    && gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner \
    && sed -i '$d' /root/.profile \
    && echo "tty -s && mesg n || true" >> /root/.profile

ADD start.sh /start.sh
WORKDIR /home/gitlab-runner

CMD ["/start.sh"]
