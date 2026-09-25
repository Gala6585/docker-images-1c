ARG BASE_IMAGE
FROM ${BASE_IMAGE}
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ALLURE_VERSION=2.29.0
ARG ALLURE_SHA256=""
COPY images/vanessa-runner-allure/scripts/ /usr/local/bin/
RUN apt-get update \
 && apt-get install -y --no-install-recommends default-jre-headless curl tar coreutils jq zip imagemagick \
 && archive="/tmp/allure-${ALLURE_VERSION}.tgz" \
 && curl --fail --location --retry 3 --output "$archive" \
      "https://github.com/allure-framework/allure2/releases/download/${ALLURE_VERSION}/allure-${ALLURE_VERSION}.tgz" \
 && if [[ -n "$ALLURE_SHA256" ]]; then echo "$ALLURE_SHA256  $archive" | sha256sum -c -; fi \
 && tar -xzf "$archive" -C /opt \
 && ln -sfn "/opt/allure-${ALLURE_VERSION}/bin/allure" /usr/local/bin/allure \
 && chmod +x /usr/local/bin/run-vanessa.sh /usr/local/bin/generate-allure-report.sh /usr/local/bin/verify-test-image.sh \
 && ln -s /usr/local/bin/run-vanessa.sh /usr/local/bin/run-vanessa \
 && ln -s /usr/local/bin/generate-allure-report.sh /usr/local/bin/generate-allure-report \
 && ln -s /usr/local/bin/verify-test-image.sh /usr/local/bin/verify-test-image \
 && mkdir -p /workspace/allure-results /workspace/allure-report /workspace/vanessa-logs \
 && verify-test-image \
 && rm -f "$archive" \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace
CMD ["run-vanessa"]
