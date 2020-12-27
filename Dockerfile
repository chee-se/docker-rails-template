FROM node:15.5.0-alpine3.12 as node
FROM ruby:2.7.2-alpine3.12

ENV APP_ROOT=/app \
    LANG=ja-JP.UTF-8

# RUN mkdir は WORKDIR で省略できる
WORKDIR $APP_ROOT

# 結果が変わらなそうなものから先に実行する
# ビルド済み node を先にコピー
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /opt/yarn-* /opt/yarn

# パッケージインストールと yarn にシンボリックリンクを張り、entryoint.sh を作る
RUN apk upgrade --no-cache && \
    apk add --no-cache \
    build-base \
    mysql-client \
    mysql-dev \
    tzdata && \
    rm -rf /usr/lib/libmysqld* && \
    echo 'install: --no-document' > ~/.gemrc && \
    echo 'update: --no-document' >> ~/.gemrc && \
    gem install bundler && \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn && \
    ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg && \
# entrypoint.sh を作成する。gem、yarnの類をインストールする。
    echo $'#!/bin/sh \n\
bundle install --path=vendor/bundle -j4 \n\
yarn \n\
bundle exec rails webpacker:install \n\
exec "$@" \n\
' > /usr/local/bin/entrypoint.sh && \
    chmod u+x /usr/local/bin/entrypoint.sh

EXPOSE 3000
