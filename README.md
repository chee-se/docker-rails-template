# docker-rails-template

my rails on docker template

## Versions

- Docker Compose 3.9
- ruby 2.7.2
- Ruby on Rails 6.1
- MySQL 8.0.2
- Node 14.15.3

## Bootstrap

1. execute command below ( avoid server start before pacakge install )

```shell
docker-compose run --rm --no-deps app bundle exec rails new . --database=mysql -B
```

and overwrite only Gemfile and package.json

2. execute command below ( install new Gemfile and package.json, then install webpacker )

```shell
docker-compose run --rm --no-deps app bundle exec rails webpacker:install
```

## Boot server

```shell
docker-compose up -d
```
