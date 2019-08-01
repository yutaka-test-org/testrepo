From ubuntu:latest
RUN set -x && apt update && apt install -y nginx && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    build-essential \
    software-properties-common \
    git \
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
    supervisor

RUN add-apt-repository -y ppa:brightbox/ruby-ng && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    ruby \
    ruby-dev \
    nginx && \
    rm -rf /var/lib/apt/lists/*

RUN gem install rubygems-update --no-document && \
    update_rubygems && \
    gem install bundler --no-document

RUN pip install awscli

WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN NOKOGIRI_USE_SYSTEM_LIBRARIES=YES bundle install

ADD . /var/source/app
WORKDIR /var/source/app
RUN mkdir -p /var/log/luccy \
             /var/run/unicorn \
             /var/log/unicorn/debug \
             /var/log/unicorn/error

COPY container/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY container/nginx/nginx.conf.erb /etc/nginx/
COPY container/nginx/luccy.conf.erb /etc/nginx/sites-available/luccy.conf.erb
COPY container/nginx/log-format.conf /etc/nginx/conf.d/
COPY container/nginx/server-status.conf /etc/nginx/conf.d/
COPY container/www/logrotate /etc/logrotate.d/www

ARG target
RUN bash -e container/onbuild.sh ${target}

RUN apt-get autoremove -y

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
