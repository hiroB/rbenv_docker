FROM centos:centos7.3.1611

ENV SETUP_HOME /opt/ruby
ENV RBENV_ROOT ${SETUP_HOME}/rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:${PATH}
ENV PATH /root/.rbenv/shims:${PATH}

RUN yum update -y
RUN yum install -y git

# see https://github.com/rbenv/ruby-build/wiki
RUN yum install -y gcc make
RUN yum install -y gcc-6 bzip2 openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

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
  && RUBY_BUILD_VERSION="master" \
  && mkdir -p "${RBENV_ROOT}/plugins" \
  && git clone https://github.com/rbenv/ruby-build.git "${RUBY_BUILD_DIR}" \
  && cd "${RUBY_BUILD_DIR}" \
  && git checkout "${RUBY_BUILD_VERSION}" \
  && rm -rf .git \
  && /bin/sh -c ./install.sh

# install runtimes and bundler
ENV BUNDLE_JOBS=2 BUNDLE_PATH=/bundle BUNDLER_VERSION=2.0.2
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