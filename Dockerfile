FROM elixir:1.10.3
WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
