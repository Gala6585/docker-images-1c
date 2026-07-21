# Container Registry

Сейчас `docker.devops.stng.ru` обслуживается GitLab Container Registry. Все образы
публикуются в namespace, заданный одной переменной:

```dotenv
DOCKER_REGISTRY_URL=docker.devops.stng.ru/devops/docker-images
```

Выполните `docker login docker.devops.stng.ru`, затем `make push-all`; для pull —
`docker pull <полное-имя>`. CI-токену нужны права GitLab Registry на чтение или
запись в зависимости от job. Не включайте insecure registry. Корпоративный CA
нужно установить в доверенное хранилище Docker/containerd на каждой ноде.
Kubernetes получает credentials через `imagePullSecret`; пример находится в
`examples/kubernetes/registry-secret.example.sh`.

Backend позднее можно заменить на Nexus или другой OCI-совместимый registry:
достаточно изменить `DOCKER_REGISTRY_URL` и учётные данные. Dockerfile и Bash-
скрипты от конкретного backend не зависят.
