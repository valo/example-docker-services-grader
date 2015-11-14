FROM ruby:2.2-onbuild

COPY . /app
WORKDIR /app

CMD bundle exec sneakers work GradeSource --require jobs.rb
