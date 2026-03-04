# Веб-приложение для домашнего задания 2 по Flutter

## Запуск

Есть 3 скрипта для запуска приложения в зависимости от операционной системы:

Файл скрипта | Операционная система | |
|--|--|--|
`windows_amd64.bat` | Windows |
`Makefile.darwin_amd64` | darwin (amd64) | macOS (Intel)
`Makefile.darwin_arm64` | darwin (arm64) | macOS (Apple Silicon M1/M2/M3)

> [WARNING] \
> PS. Для macOS не тестировалось :)

___

По умолчанию, сервер запускается на порту `8080`. Если по каким-то причинам, надо изменить порт, то необходимо изменить в скрипте переменную `APP_PORT`.


## API

URL | Method | Body | Reponse | |
|--|--|--|--|--|
`/api/sign-up` | POST | JSON: `{email: string, password: string}` | JSON: `{api_key}` | Регистрация пользователя. Ответ: токен для `api.thecatapi.com`
`/api/sign-in` | POST | JSON: `{email: string, password: string}` | JSON: `{api_key}` | Авторизация существующего пользователя. Ответ: токен для `api.thecatapi.com`
`/api/analytics` | POST | JSON: `{event: string, data: dict}` | `NoContent` | Отправка лога на сервер


<br>

## Компиляция исполняемых файлов

Операционная система | Команда
|--|--|
Windows | `GOOS=windows GOARCH=amd64 go build -o windows_amd64.exe`
|       | `$env:GOOS="windows"; $env:GOARCH="amd64"; go build -o windows_amd64.exe`
darwin (amd64) | `GOOS=darwin GOARCH=amd64 go build -o darwin_amd64`
|              | `$env:GOOS="darwin"; $env:GOARCH="amd64"; go build -o darwin_amd64`
darwin (arm64) | `GOOS=darwin GOARCH=arm64 go build -o darwin_arm64`
|              | `$env:GOOS="darwin"; $env:GOARCH="arm64"; go build -o darwin_arm64`

