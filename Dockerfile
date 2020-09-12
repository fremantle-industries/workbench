FROM elixir:1.11.1 as build

# Install deps for phoenix
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get  update 
RUN apt-get install -y \
      make \
      g++ \
      wget \
      curl \
      inotify-tools \
      nodejs

RUN update-ca-certificates --fresh

ENV PATH=./node_modules/.bin:$PATH

# Install rebar and hex
RUN mix do local.hex --force, local.rebar --force

# Setup directory

RUN mkdir /app
WORKDIR /app

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Build frontend
COPY assets assets
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# Build release
COPY priv priv
COPY lib lib
RUN mix compile
RUN mix release workbench

# prepare release image
FROM buildpack-deps:buster AS prod

# install runtime dependencies
RUN apt-get update
RUN apt-get install -y openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod
ENV LANG=C.UTF-8

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /app/_build/prod/rel/workbench .
COPY start.sh .
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app
ENTRYPOINT ["/app/start.sh"]
