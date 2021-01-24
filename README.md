# docker-rails-template

my rails on docker template

## Versions

- Docker Compose 3.9
- ruby 2.7.2
- Ruby on Rails 6.1
- MySQL 8.0.2
- Node 14.15.3

## Bootstrap

1. execute command below ( update gems )

```shell
docker-compose run --rm --no-deps app bundle update && yarn upgrade
```

1. execute command below ( generate credentials )

```shell
docker-compose run --rm --no-deps app EDITOR="vi" bundle exec rails bin/rails credentials:edit
```

## Boot server

```shell
docker-compose up -d
```
