# Back Office
[![Build Status](https://github.com/fremantle-capital/back_office/workflows/CI/badge.svg)](https://github.com/fremantle-capital/back_office/actions?query=workflow%3ACI)

Manage operations of a fund

## Test

```bash
$ MIX_ENV=test mix ecto.create
$ MIX_ENV=test mix ecto.migrate
$ mix test
```

## Development

```bash
$ mix ecto.create
$ mix ecto.migrate
$ mix phx.server
```

## Production

```bash
$ MIX_ENV=prod mix ecto.create
$ MIX_ENV=prod mix ecto.migrate
$ MIX_ENV=prod \
DATABASE_URL=ecto://user@localhost/back_office_prod \
SECRET_KEY_BASE=(mix phx.gen.secret) \
LIVE_VIEW_SIGNING_SALT=(mix phx.gen.secret 32) \
GUARDIAN_SECRET_KEY=(mix guardian.gen.secret) \
mix phx.server
```
