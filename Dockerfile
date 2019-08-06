From FROM ubuntu:bionic


ENV DEBIAN_FRONTEND noninteractive

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    software-properties-common \
    git \
    mysql-client \
    redis-tools \
    libmysqld-dev \
    libsqlite3-dev \
    libxml2-dev \
    libxslt-dev \
    imagemagick \
    libmagickwand-dev \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    python3-pip \
    libyaml-dev \
    python3-dev \
    supervisor \
    openssh-client \
    libssl-dev \
    curl \
    python3-setuptools \
    file


RUN apt-get install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ruby
RUN add-apt-repository -y ppa:brightbox/ruby-ng && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    ruby2.5 \
    ruby2.5-dev \
    nginx

# gem
RUN gem install rubygems-update --no-document && \
    update_rubygems && \
    gem install bundler --no-document

# awscli
RUN pip3 install awscli && \
    rm -rf /var/lib/apt/lists/*

# node
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v7.2.0

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

# mysql-client
COPY container/mysql/aumo.cnf /etc/mysql/conf.d


# nginx
RUN set -x && apt update && apt install -y nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN apt-get autoremove -y

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
