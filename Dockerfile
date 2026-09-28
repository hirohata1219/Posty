FROM ruby:3.4.10-slim

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libpq-dev \
      git \
      curl \
      libyaml-dev \
      pkg-config \
    && rm -rf /var/lib/apt/lists/*

# ホスト側ユーザーと同じUID/GIDのユーザーを作成
ARG UID=1000
ARG GID=1000

RUN groupadd --gid ${GID} appgroup && \
    useradd --uid ${UID} --gid ${GID} --create-home --shell /bin/bash appuser

# Railsアプリの場所
WORKDIR /app

# BundlerのGem保存先
ENV BUNDLE_PATH=/bundle

# Gem保存先を作成
RUN mkdir -p /bundle && \
    chown -R appuser:appgroup /bundle

# 以降はappuserで実行
USER appuser

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]