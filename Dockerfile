FROM bitwalker/alpine-elixir-phoenix

WORKDIR /app

COPY ./mix.exs ./
COPY ./mix.lock ./
COPY ./assets/css ./assets/css
COPY ./assets/js ./assets/js
COPY ./assets/static ./assets/static
COPY ./assets/package.json ./assets/package.json
COPY ./assets/package-lock.json ./assets/package-lock.json
COPY ./assets/webpack.config.js ./assets/webpack.config.js
COPY ./assets/tsconfig.json ./assets/tsconfig.json
COPY ./assets/tsconfig.cjs.json ./assets/tsconfig.cjs.json
COPY ./assets/tsconfig.es6.json ./assets/tsconfig.es6.json
COPY ./config ./config
COPY ./lib ./lib
COPY ./priv ./priv
RUN mix deps.get
# npm can be flaky, so fetch dependencies & fail fast
RUN mix setup.assets
RUN mix deps.compile
RUN mix compile

ENTRYPOINT ["mix phx.server"]
