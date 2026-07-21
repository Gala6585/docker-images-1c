ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}

ARG ONEC_FULL_VERSION=8.5.1.1343
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=ru_RU.UTF-8 \
    LC_ALL=ru_RU.UTF-8 \
    NO_AT_BRIDGE=1 \
    GDK_BACKEND=x11

COPY distr/1c/ /tmp/onec/
COPY images/1c-platform/scripts/ /usr/local/lib/onec/
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl bash locales fontconfig \
      fonts-dejavu fonts-liberation xvfb xauth dbus-x11 at-spi2-core libatk-bridge2.0-0 \
      libgtk-3-0 libnss3 libx11-6 libxext6 libxi6 libxtst6 libxrender1 libfreetype6 \
      libglib2.0-0 libgl1 libglu1-mesa \
 && locale-gen ru_RU.UTF-8 \
 && if apt-cache show libwebkit2gtk-4.0-37 >/dev/null 2>&1; then apt-get install -y --no-install-recommends libwebkit2gtk-4.0-37; \
    elif apt-cache show libwebkit2gtk-4.1-0 >/dev/null 2>&1; then apt-get install -y --no-install-recommends libwebkit2gtk-4.1-0; fi \
 && (dpkg -i /tmp/onec/*.deb || (apt-get update && apt-get install -f -y && dpkg -i /tmp/onec/*.deb)) \
 && chmod +x /usr/local/lib/onec/*.sh \
 && /usr/local/lib/onec/detect-1c-binary.sh \
 && /usr/local/lib/onec/verify-platform.sh \
 && rm -rf /tmp/onec /var/lib/apt/lists/*

LABEL org.opencontainers.image.title="1C thin client platform" \
      ru.stng.onec.version="${ONEC_FULL_VERSION}"
