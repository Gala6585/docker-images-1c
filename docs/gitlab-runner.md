# GitLab Runner в MicroK8s

Примеры рассчитаны на Kubernetes executor, namespace `gitlab-runner` и tag
`microk8s`. Установите корпоративный CA на каждой ноде, создайте `imagePullSecret`
и подключите его к service account/Runner pod spec. Используйте неизменяемый тег
конечного образа. Строку подключения, пользователя и пароль задавайте masked и,
при необходимости, protected CI/CD Variables. Результаты, отчёт и логи сохраняйте
как artifacts с `when: always`; не публикуйте EPF и информационную базу.

