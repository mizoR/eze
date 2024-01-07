FROM ruby:3.2.2

ARG USER=cmd
ARG GROUP=cmd
ARG UID=1000
ARG GID=1000

RUN apt-get update -qq && apt-get install -y build-essential

RUN groupadd -g $GID $GROUP && useradd -m -s /bin/bash -u $UID -g $GID $USER

RUN mkdir -m 755 /cmd && chown $USER:$GROUP /cmd

USER $USER

WORKDIR /cmd

RUN bundle config set force_ruby_platform true

ADD eze.gemspec /cmd/eze.gemspec

ADD lib/eze/version.rb /cmd/lib/eze/version.rb

ADD Gemfile /cmd/Gemfile

ADD Gemfile.lock /cmd/Gemfile.lock

RUN bundle

ADD . /cmd
