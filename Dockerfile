FROM ruby:2.6.2
ENV LANG C.UTF-8

ENV SETUP_HOME /opt/ruby
ENV RBENV_ROOT ${SETUP_HOME}/rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}

# essential
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev cmake

# see: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
# not install libgdbm5
RUN apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev

# install rbenv
# see: https://github.com/rbenv/rbenv/releases
RUN RBENV_VERSION="v1.1.2" \
  && git clone https://github.com/rbenv/rbenv.git "${RBENV_ROOT}" \
  && cd "${RBENV_ROOT}" \
  && git checkout "${RBENV_VERSION}" \
  && src/configure && make -C src \
  && rm -rf .git

# install ruby-build
# see: https://github.com/rbenv/ruby-build/releases
RUN RUBY_BUILD_DIR="${RBENV_ROOT}/plugins/ruby-build" \
  && RUBY_BUILD_VERSION="v20190615" \
  && mkdir -p "${RBENV_ROOT}/plugins" \
  && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
  && cd "${RUBY_BUILD_DIR}" \
  && git checkout "${RUBY_BUILD_VERSION}" \
  && rm -rf .git

# install runtimes and bundler
ENV BUNDLE_JOBS=4 BUNDLE_PATH=/bundle BUNDLER_VERSION=2.0.2
ENV CURRENT_RUBY_VERSION=2.6.3
RUN unset GEM_HOME \
  && for version in "2.6.3"; do \
    rbenv install "${version}" \
    && rbenv global "${version}" \
    && echo 'gem: --no-rdoc --no-ri' >> /.gemrc \
    && gem update bundler \
    && gem install bundler -v ${BUNDLER_VERSION} \
  ; done \
  && rbenv versions \
  && rbenv global $CURRENT_RUBY_VERSION

# application home
RUN mkdir /app
WORKDIR /app

EXPOSE 3000 8090