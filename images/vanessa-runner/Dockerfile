ARG BASE_IMAGE
FROM ${BASE_IMAGE}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG INSTALL_OSCRIPT_FROM_LOCAL=false
ARG OSCRIPT_VERSION=1.9.4
ARG OSCRIPT_SHA256
ARG VANESSA_RUNNER_VERSION=2.6.1
COPY distr/oscript/ /tmp/oscript/
COPY images/vanessa-runner/scripts/ /usr/local/lib/vanessa-runner/
RUN apt-get update \
 && apt-get install -y --no-install-recommends git bash curl unzip \
 && if [[ "${INSTALL_OSCRIPT_FROM_LOCAL}" == "true" ]]; then \
      files=(/tmp/oscript/*.deb); [[ -e "${files[0]}" ]] || { echo 'Нет локального OneScript .deb' >&2; exit 1; }; \
      dpkg -i "${files[@]}" || (apt-get install -f -y && dpkg -i "${files[@]}"); \
    else \
      [[ "$OSCRIPT_VERSION" != "latest" ]] || { echo 'OSCRIPT_VERSION должен быть фиксированным' >&2; exit 1; }; \
      [[ "$OSCRIPT_SHA256" =~ ^[0-9a-fA-F]{64}$ ]] || { echo 'Нужен корректный OSCRIPT_SHA256' >&2; exit 1; }; \
      url="https://github.com/EvilBeaver/OneScript/releases/download/v${OSCRIPT_VERSION}/onescript-engine_${OSCRIPT_VERSION}_all.deb"; \
      curl --fail --location --retry 3 --output /tmp/onescript.deb "$url"; \
      echo "${OSCRIPT_SHA256}  /tmp/onescript.deb" | sha256sum -c -; \
      dpkg -i /tmp/onescript.deb || (apt-get install -f -y && dpkg -i /tmp/onescript.deb); \
    fi \
 && opm install "vanessa-runner@${VANESSA_RUNNER_VERSION}" \
 && chmod +x /usr/local/lib/vanessa-runner/*.sh \
 && /usr/local/lib/vanessa-runner/verify-vanessa-runner.sh \
 && rm -rf /tmp/oscript /tmp/onescript.deb /var/lib/apt/lists/*
