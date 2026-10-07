FROM ruby:4.0.6-bookworm

EXPOSE 4567:4567
EXPOSE 35729:35729

WORKDIR /usr/src/gems

COPY ./Gemfile /usr/src/gems
COPY ./Gemfile.lock /usr/src/gems

RUN apt-get update \
  && apt-get install -y --no-install-recommends nodejs clang \
  && rm -rf /var/lib/apt/lists/*

RUN bundle config set force_ruby_platform true
RUN bundle install
RUN bundle check

WORKDIR /usr/src/docs

RUN useradd --create-home middleman
USER middleman

CMD [ "bundle", "exec", "--gemfile=/usr/src/gems/Gemfile", "middleman", "server" ]
