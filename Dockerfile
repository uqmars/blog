# Local development only. NOT used for deployment (GitHub Pages builds the site).
FROM ruby:3.4-alpine AS build

# Toolchain needed to compile native gems on musl (commonmarker builds from Rust).
RUN apk add --no-cache build-base rust cargo openssl-dev

WORKDIR /srv/jekyll
COPY Gemfile* ./
RUN gem install bundler -v 4.0.24 \
 && bundle _4.0.24_ install --jobs 4

FROM ruby:3.4-alpine

# Runtime libs for the compiled extensions; no compilers in the final image.
RUN apk add --no-cache libstdc++ tzdata

WORKDIR /srv/jekyll
COPY --from=build /usr/local/bundle /usr/local/bundle

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--force_polling"]
