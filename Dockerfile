FROM bitwalker/alpine-elixir-phoenix:latest AS builder

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
COPY ./config ./config
COPY ./lib ./lib
COPY ./priv/repo ./priv/repo
RUN mix setup.deps

FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app
COPY --from=builder /app .

ENTRYPOINT ["mix phx.server"]
