FROM jlesage/baseimage-gui:ubuntu-24.04-v4.9

ARG PP_VERSION=0.80.4

WORKDIR /tmp

RUN \
  echo "**** install packages ****" && \
  mkdir -p /usr/share/man/man1 && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    curl \
    default-jdk \
    thunar &&\
  echo "**** install portfolio performance ****" && \
  if [ -z ${PP_VERSION+x} ]; then \
    PP_VERSION=$(curl -sLX GET "https://api.github.com/repos/portfolio-performance/portfolio/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "**** version: ${PP_VERSION} ****" && \
  echo "https://github.com/portfolio-performance/portfolio/releases/download/${PP_VERSION}/PortfolioPerformance-${PP_VERSION}-linux.gtk.x86_64.tar.gz" && \
  curl -o \
    /tmp/pp.tgz -L \
    "https://github.com/portfolio-performance/portfolio/releases/download/${PP_VERSION}/PortfolioPerformance-${PP_VERSION}-linux.gtk.x86_64.tar.gz" && \
  tar -zxf /tmp/pp.tgz -C /usr/share && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN \
    APP_ICON_URL="https://avatars.githubusercontent.com/u/76070034?s=48&v=4" && \
    install_app_icon.sh "$APP_ICON_URL"

RUN \
    set-cont-env APP_NAME "Portfolio Performance" && \
    set-cont-env DOCKER_IMAGE_VERSION "$PP_VERSION" && \
    true

LABEL \
  org.label-schema.name="Portfolio Performance" \
  org.label-schema.description="Track and evaluate the performance of your investment portfolio across stocks, cryptocurrencies, and other assets" \
  org.label-schema.version="${PP_VERSION:-dev}" \
  org.label-schema.vcs-url="https://github.com/portfolio-performance/portfolio" \
  org.label-schema.schema-version="1.0"

COPY rootfs/ /

RUN mkdir -p /data && chown 1000:1000 /data

VOLUME ["/data"]

RUN chmod +x /startapp.sh
