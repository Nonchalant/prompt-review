FROM ruby:2.2.2

USER root
COPY ./main.rb ./Gemfile ./Gemfile.lock ./.ruby-version ./conf.yml /app/

WORKDIR /app
RUN bundle install --path=vendor/bundle

CMD ["bundle", "exec", "ruby", "main.rb", "./conf.yml"]
