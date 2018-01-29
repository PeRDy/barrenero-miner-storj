FROM node:boron-alpine
LABEL maintainer="José Antonio Perdiguero López <perdy.hh@gmail.com>"

ENV APP=barrenero-miner-storj

RUN apk add --no-cache \
        bash \
        g++ \
        git \
        make \
        openssl-dev \
        python \
        python3 && \
    npm install --global storjshare-daemon && \
    npm cache clean --force && \
    apk del \
        git \
        openssl-dev \
        python && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/npm*

# Create project dirs
RUN mkdir -p /srv/apps/$APP/logs
RUN mkdir -p /srv/apps/$APP/storage
WORKDIR /srv/apps/$APP

# Install python requirements
COPY requirements.txt constraints.txt /srv/apps/$APP/
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install --no-cache-dir -r requirements.txt -c constraints.txt && \
    rm -rf $HOME/.cache/pip/*

# Copy application
COPY . /srv/apps/$APP/

ENTRYPOINT ["./run"]