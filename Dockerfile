FROM python:3.12-slim

ENV APP_USER=bootstrapper
ENV APP_HOME=/home/$APP_USER/app

# Install the Google Cloud SDK
RUN apt-get update && apt-get -y install apt-transport-https ca-certificates gnupg curl && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.asc] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.asc &&\
    apt-get update && apt-get -y install google-cloud-cli

## install Cloud bootstrapper Pythonic CLI
RUN pip install cloudboot

# Create a non-root user and switch to it
RUN useradd -p "" -ms /bin/bash $APP_USER
USER $APP_USER

RUN mkdir /home/$APP_USER/.config

# Set the working directory to the application home directory
WORKDIR $APP_HOME

ENTRYPOINT ["cloudboot"]
