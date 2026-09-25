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
3. Скачайте официальный `OneScript-2.0.1-linux-x64.zip`, проверьте SHA-256 и
   положите его в `distr/oscript/`. По умолчанию используется закрытый режим
   `INSTALL_OSCRIPT_FROM_LOCAL=true`. При явном значении `false` тот же архив
   загружается из GitHub Release; checksum проверяется в обоих режимах.
4. Выполните `make validate`, затем `make build-all` и проверки `make check-*`.
5. Выполните `docker login docker.devops.stng.ru` и `make push-all`.

Образ для распаковки файлов 1С в GitLab CI собирается отдельно из фиксированного
commit репозитория `Gala6585/v8unpack`:

```bash
make build-v8unpack
make check-v8unpack
make push-v8unpack
```

Во время GitLab job пакеты не устанавливаются: `v8unpack`, Python, Git и
системные утилиты уже находятся в опубликованном образе.

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

