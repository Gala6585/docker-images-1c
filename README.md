# Docker-образы 1С и Vanessa Automation

Репозиторий собирает внутреннюю трёхслойную цепочку образов: `1c-platform`
(thin client 1С) → `vanessa-runner` (OneScript и vanessa-runner 2.6.1) →
`vanessa-runner-allure` (Java, Allure CLI и команды запуска тестов). Закрытые
дистрибутивы, EPF, базы и секреты в Git не добавляются.

## Быстрый старт

1. Скопируйте `.env.example` в `.env` и задайте registry/версии. Сейчас образы
   публикуются в GitLab Container Registry через
   `DOCKER_REGISTRY_URL=docker.devops.stng.ru/devops/docker-images`.
2. Поместите пакеты `*thin-client*.deb` версии `ONEC_FULL_VERSION` для `amd64` в
   `distr/1c/`; не добавляйте пакеты common/client/server/ws/crs.
3. По умолчанию OneScript 1.9.4 загружается из официального GitHub Release и
   обязательно проверяется по `OSCRIPT_SHA256`. Для закрытой сети задайте
   `INSTALL_OSCRIPT_FROM_LOCAL=true` и положите `.deb` в `distr/oscript/`.
4. Выполните `make validate`, затем `make build-all` и проверки `make check-*`.
5. Выполните `docker login docker.devops.stng.ru` и `make push-all`.

Production-сборка выполняется только локально или на внутреннем/self-hosted
Runner. Публичные GitHub Actions выполняют лишь lint и безопасную validation.

## Запуск тестов

Скопируйте `examples/project/ci/VAParams.example.json` в `ci/VAParams.json`,
положите Vanessa EPF в `tools/vanessa/vanessa-automation-single.epf`, feature-файлы
в `features/` и задайте `TEST_BASE_CONNECTION_STRING`. Для файловой базы это,
например, `/F/workspace/base`, для серверной — `/Sserver\base`; реальные строки и
пароли храните только в CI variables. Команда `run-vanessa` запускает 1С через
DBus/Xvfb с timeout и пишет логи. Затем `generate-allure-report` формирует отчёт.

## Команды

`make print-images` выводит полные неизменяемые теги. Доступны `validate`, `lint`,
`build-platform`, `build-vanessa-runner`, `build-vanessa-allure`, `build-all`,
`check-platform`, `check-vanessa-runner`, `check-vanessa-allure`, соответствующие
`push-*` и `push-all`.

Подробности: [архитектура](docs/architecture.md), [сборка](docs/build.md),
[registry](docs/registry.md), [GitLab Runner](docs/gitlab-runner.md) и
[решение проблем](docs/troubleshooting.md).
