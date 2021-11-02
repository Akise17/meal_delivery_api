FROM ruby:2.7.2

# RUN apk add --update --virtual \
#   runtime-deps \
#   build-base \
#   libxml2-dev \
#   libxslt-dev \
#   nodejs \
#   yarn \
#   libffi-dev \
#   readline \
#   build-base \
#   sqlite-dev \
#   libc-dev \
#   linux-headers \
#   readline-dev \
#   file \
#   imagemagick \
#   git \
#   tzdata \
#   && rm -rf /var/cache/apk/*

WORKDIR /app
COPY . /app/

ENV BUNDLE_PATH /gems
RUN yarn install
RUN bundle install

ENTRYPOINT ["bin/rails"]
CMD ["s", "-b", "0.0.0.0"]

EXPOSE 3000