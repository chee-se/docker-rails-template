# FROMの前のARGはレイヤー化しないが、ビルドステージで使えない（FROMにのみ有効）
ARG NODE_VERSION
ARG ALPINE_VERSION
ARG RUBY_VERSION
FROM node:$NODE_VERSION-alpine$ALPINE_VERSION as node
FROM ruby:$RUBY_VERSION-alpine$ALPINE_VERSION

# ENVはコンテナ内で環境変数として使いたい定数を指定する。ビルドのみ必要な定数はARGで十分
# key=valueの形にすることで一度に複数定義可能。レイヤーも一つで済む
ENV APP_ROOT=/app \
    LANG=ja-JP.UTF-8 \
    TZ=Asia/Tokyo

# RUN mkdir は WORKDIR で省略できる
WORKDIR $APP_ROOT

# 結果が変わらなそうなものから先に実行する
# ビルド済み node をコピー
COPY --from=node /usr/local/bin/node /usr/local/bin/
COPY --from=node /opt/yarn-* /opt/yarn

# node にシンボリックリンクを張る
RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn && \
    ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg && \
    # gem インストール
    echo 'install: --no-document' > ~/.gemrc && \
    echo 'update: --no-document' >> ~/.gemrc && \
    bundle config --path=vendor/bundle && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    # linux-headers \
    # libxml2-dev \
    # make \
    # git \
        # curl-dev \
        mysql-client \
        mysql-dev \
        tzdata && \
    rm -rf /usr/lib/libmysqld* && \
    rm -rf /usr/bin/mysql*

# Gemfile が変更された場合、ここからビルドしなおしになる
# 最初にCOPYを済ませて一つのRUNですべて処理することもできるが、せいぜい0.1MBの節約にしかならない
COPY Gemfile Gemfile.lock package.json yarn.lock ./

# ビルド用パッケージはレイヤーキャッシュさせずにすぐに捨てる
RUN apk add --no-cache --virtual build-dependencies \
        build-base && \
    bundle install -j4 && yarn && \
    apk del build-dependencies

EXPOSE 3000
