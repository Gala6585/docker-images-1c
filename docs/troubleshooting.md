# Решение проблем

- `which 1cv8` падает: thin client предоставляет `1cv8c`.
- `libGLU.so.1 not found`: нужен пакет `libglu1-mesa`; повторите сборку слоя.
- DBus/AT-SPI warning: запускайте через `dbus-run-session`, задайте
  `NO_AT_BRIDGE=1` и используйте Xvfb.
- `1cv8c /Version` зависает: не используйте эту GUI-команду как healthcheck.
- Конфликт thin-client/common: удалите common/client/server/ws/crs из `distr/1c`.
- Registry `401 Unauthorized`: проверьте `docker login`, токен и права GitLab
  Container Registry для проекта/namespace.
- `x509: certificate signed by unknown authority`: установите корпоративный CA на
  каждой MicroK8s node и перезапустите containerd.
- `ImagePullBackOff`: проверьте полное имя/тег, CA, `imagePullSecret` и namespace.
- Пустой `allure-results`: проверьте VAParams и включённый Allure-формат Vanessa.
- Нет `vanessa-automation-single.epf`: смонтируйте EPF по `VANESSA_EPF`.
- Нет тестовой базы: проверьте файловый volume или доступность server/base.
- Timeout Vanessa: изучите `vanessa-logs/platform.log`, затем обоснованно увеличьте
  `VANESSA_TIMEOUT_SECONDS`.
- В 2.6.1 используется `vrunner vanessa`; команда `vrunner test vanessa` относится
  к 3.x и требует отдельного профиля совместимости.
