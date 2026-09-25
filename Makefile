SHELL := bash
.PHONY: validate lint build-v8unpack build-platform build-vanessa-runner build-vanessa-allure build-all check-v8unpack check-platform check-vanessa-runner check-vanessa-allure push-v8unpack push-platform push-vanessa-runner push-vanessa-allure push-all print-images

validate:
	bash scripts/validate-structure.sh
	bash scripts/validate-distr.sh
lint:
	@command -v shellcheck >/dev/null && shellcheck $$(find . -type f \( -name '*.sh' -o -path '*/scripts/*' \) ! -name .gitkeep) || echo 'shellcheck не установлен'
	@command -v hadolint >/dev/null && hadolint images/*/Dockerfile || echo 'hadolint не установлен'
build-platform: validate
	bash scripts/build-platform.sh
build-v8unpack:
	bash scripts/build-v8unpack.sh
build-vanessa-runner: validate
	bash scripts/build-vanessa-runner.sh
build-vanessa-allure: validate
	bash scripts/build-vanessa-allure.sh
build-all: validate
	bash scripts/build-all.sh
check-platform:
	bash scripts/check-image.sh platform
check-vanessa-runner:
	bash scripts/check-image.sh runner
check-vanessa-allure:
	bash scripts/check-image.sh allure
check-v8unpack:
	bash scripts/check-image.sh v8unpack
push-platform:
	bash scripts/push-image.sh platform
push-vanessa-runner:
	bash scripts/push-image.sh runner
push-vanessa-allure:
	bash scripts/push-image.sh allure
push-v8unpack:
	bash scripts/push-image.sh v8unpack
push-all:
	bash scripts/push-all.sh
print-images:
	@bash -c 'source scripts/common.sh; printf "%s\n%s\n%s\n%s\n" "$$PLATFORM_IMAGE" "$$RUNNER_IMAGE" "$$ALLURE_IMAGE" "$$V8UNPACK_IMAGE"'
