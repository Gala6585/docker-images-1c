ARG PYTHON_BASE_IMAGE=python:3.11-slim-bookworm

FROM ${PYTHON_BASE_IMAGE} AS builder
ARG V8UNPACK_REPOSITORY=https://github.com/Gala6585/v8unpack.git
ARG V8UNPACK_REF=bb0a133caaf1710a95364c478d5d36d8190d1eb1

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates git \
 && git clone "${V8UNPACK_REPOSITORY}" /src \
 && git -C /src checkout --detach "${V8UNPACK_REF}" \
 && test "$(git -C /src rev-parse HEAD)" = "${V8UNPACK_REF}" \
 && python -m pip wheel --wheel-dir /wheels /src \
 && rm -rf /var/lib/apt/lists/*

FROM ${PYTHON_BASE_IMAGE}
ARG V8UNPACK_VERSION=1.2.9
ARG V8UNPACK_REF=bb0a133caaf1710a95364c478d5d36d8190d1eb1

RUN apt-get update \
 && apt-get install -y --no-install-recommends bash ca-certificates findutils git \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /wheels/ /wheels/
RUN python -m pip install --no-cache-dir --no-index --find-links=/wheels "v8unpack==${V8UNPACK_VERSION}" \
 && python -c "import v8unpack.version as v; assert v.__version__ == '${V8UNPACK_VERSION}', v.__version__" \
 && v8unpack --help >/dev/null \
 && rm -rf /wheels

WORKDIR /builds

LABEL org.opencontainers.image.title="v8unpack for GitLab CI" \
      org.opencontainers.image.source="https://github.com/Gala6585/v8unpack" \
      org.opencontainers.image.version="${V8UNPACK_VERSION}" \
      org.opencontainers.image.revision="${V8UNPACK_REF}"
