# docker-rails-template

my rails on docker template

## Versions

- Docker Compose 3.7
- ruby 2.7.2
- Ruby on Rails 6.1
- MySQL 8.0.2
- Node 15.5.0

## Bootstrap

```shell
$ docker-compose run --rm app bundle exec rails new . --database=mysql -B
$ docker-compose run --rm app bundle && yarn && bundle exec rails webpacker:install
```

## Boot server

```shell
$ docker-compose up -d
```
