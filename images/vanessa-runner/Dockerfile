ARG BASE_IMAGE
FROM ${BASE_IMAGE}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG INSTALL_OSCRIPT_FROM_LOCAL=true
ARG OSCRIPT_VERSION=2.0.1
ARG OSCRIPT_SHA256
ARG VANESSA_RUNNER_VERSION=2.6.1
COPY distr/oscript/ /tmp/oscript/
COPY images/vanessa-runner/scripts/ /usr/local/lib/vanessa-runner/
RUN apt-get update \
 && apt-get install -y --no-install-recommends git bash curl unzip \
 && archive=/tmp/onescript.zip \
 && if [[ "${INSTALL_OSCRIPT_FROM_LOCAL}" == "true" ]]; then \
      local_archive="/tmp/oscript/OneScript-${OSCRIPT_VERSION}-linux-x64.zip"; \
      [[ -f "$local_archive" ]] || { echo "Нет локального архива $local_archive" >&2; exit 1; }; \
      cp "$local_archive" "$archive"; \
    else \
      [[ "$OSCRIPT_VERSION" != "latest" ]] || { echo 'OSCRIPT_VERSION должен быть фиксированным' >&2; exit 1; }; \
      [[ "$OSCRIPT_SHA256" =~ ^[0-9a-fA-F]{64}$ ]] || { echo 'Нужен корректный OSCRIPT_SHA256' >&2; exit 1; }; \
      url="https://github.com/EvilBeaver/OneScript/releases/download/v${OSCRIPT_VERSION}/OneScript-${OSCRIPT_VERSION}-linux-x64.zip"; \
      curl --fail --location --retry 3 --output "$archive" "$url"; \
    fi \
 && echo "${OSCRIPT_SHA256}  $archive" | sha256sum -c - \
 && mkdir -p /opt/onescript \
 && unzip -q "$archive" -d /opt/onescript \
 && chmod +x /opt/onescript/bin/oscript /opt/onescript/bin/opm \
 && printf '%s\n' '#!/usr/bin/env bash' 'exec /opt/onescript/bin/oscript "$@"' > /usr/local/bin/oscript \
 && printf '%s\n' '#!/usr/bin/env bash' 'exec /opt/onescript/bin/opm "$@"' > /usr/local/bin/opm \
 && chmod +x /usr/local/bin/oscript /usr/local/bin/opm \
 && opm version \
 && opm install "vanessa-runner@${VANESSA_RUNNER_VERSION}" \
 && chmod +x /usr/local/lib/vanessa-runner/*.sh \
 && /usr/local/lib/vanessa-runner/verify-vanessa-runner.sh \
 && rm -rf /tmp/oscript /tmp/onescript.zip /var/lib/apt/lists/*
