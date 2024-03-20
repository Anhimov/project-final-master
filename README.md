## [REST API](http://localhost:8080/doc)

## Концепция:

- Spring Modulith
    - [Spring Modulith: достигли ли мы зрелости модульности](https://habr.com/ru/post/701984/)
    - [Introducing Spring Modulith](https://spring.io/blog/2022/10/21/introducing-spring-modulith)
    - [Spring Modulith - Reference documentation](https://docs.spring.io/spring-modulith/docs/current-SNAPSHOT/reference/html/)

```
  url: jdbc:postgresql://localhost:5432/jira
  username: jira
  password: JiraRush
```

- Есть 2 общие таблицы, на которых не fk
    - _Reference_ - справочник. Связь делаем по _code_ (по id нельзя, тк id привязано к окружению-конкретной базе)
    - _UserBelong_ - привязка юзеров с типом (owner, lead, ...) к объекту (таска, проект, спринт, ...). FK вручную будем
      проверять

## Аналоги

- https://java-source.net/open-source/issue-trackers

## Тестирование

- https://habr.com/ru/articles/259055/

## Список выполненных задач:
### 2. Удалить социальные сети: vk, yandex
### 3. Вынести чувствительную информацию в отдельный проперти файл:
#### созданы файлы:
- [application-sensitive.yaml](src%2Fmain%2Fresources%2Fapplication-sensitive.yaml)
- [.env](.env)
#### Чтобы запустить приложение в IDE необходимо передать файл .env в Environment variables в конфигурацию.
### 4. Переделать тесты так, чтоб во время тестов использовалась in memory БД (H2)
- создан файл [application-testH2.yaml](src%2Ftest%2Fresources%2Fapplication-testH2.yaml)
- файл [application-testPostgres.yaml](src%2Ftest%2Fresources%2Fapplication-testPostgres.yaml) переименован
- в этом файле [BaseTests.java](src%2Ftest%2Fjava%2Fcom%2Fjavarush%2Fjira%2FBaseTests.java) можно указать профиль как запускать тестовую базу либо "testH2" либо "testPostgres"
- в этом файле [AbstractControllerTest.java](src%2Ftest%2Fjava%2Fcom%2Fjavarush%2Fjira%2FAbstractControllerTest.java) нужно поменять используемый скрипт
### 5. Написать тесты для всех публичных методов контроллера ProfileRestController.
- тесты написаны в этом классе [ProfileRestControllerTest.java](src%2Ftest%2Fjava%2Fcom%2Fjavarush%2Fjira%2Fprofile%2Finternal%2Fweb%2FProfileRestControllerTest.java)
### 6. Сделать рефакторинг метода com.javarush.jira.bugtracking.attachment.FileUtil#upload
- переделал метод в файле [FileUtil.java](src%2Fmain%2Fjava%2Fcom%2Fjavarush%2Fjira%2Fbugtracking%2Fattachment%2FFileUtil.java)
- использовал классы Path и Files
### 8. Добавить подсчет времени сколько задача находилась в работе и тестировании.
- добавил два метода в этот класс [TaskService.java](src%2Fmain%2Fjava%2Fcom%2Fjavarush%2Fjira%2Fbugtracking%2Ftask%2FTaskService.java)
- добавил метод в репозиторий [ActivityRepository.java](src%2Fmain%2Fjava%2Fcom%2Fjavarush%2Fjira%2Fbugtracking%2Ftask%2FActivityRepository.java)
- добавил в sql скрипт [changelog.sql](src%2Fmain%2Fresources%2Fdb%2Fchangelog.sql) запись на добавление строк в таблицн. Правда, эту запись пришлось в последствии на пункте 10 закомментировать - мешало docker-compose up.
### 9. Написать Dockerfile для основного сервера
- создан [Dockerfile](Dockerfile)
### 10. Написать docker-compose файл для запуска контейнера сервера вместе с БД и nginx.
- создан [docker-compose.yaml](docker-compose.yaml)
- переделан файл [nginx.conf](config%2Fnginx.conf)
- если версия докера 4.27.1, то нужно обновить его до версии (у меня установлен Desktop Docker Windows 4.28.0), иначе может возникнуть ошибка https://stackoverflow.com/questions/77993212/docker-compose-build-failed-to-solve-changes-out-of-order
- проект собрался, но с проблемами:
- неправильно отображается заголовок, но это скорее всего из-за языковых шаблонов, которые реализованы в следующем пункте, но еще не полностью работают
- swagger работает, но не проходит аутентификация.
### 11. Добавить локализацию минимум на двух языках для шаблонов писем (mails) и стартовой страницы index.html.
- были изменены файлы шаблонов - вставлены ссылки на переменные [password-reset.html](resources%2Fmails%2Fpassword-reset.html), [email-confirmation.html](resources%2Fmails%2Femail-confirmation.html) и [index.html](resources%2Fview%2Findex.html)
- создана папка `Resource Bundle 'messages'` с файлами языковых профилей для русского, английского и испанского языков:
[messages_en.properties](src%2Fmain%2Fresources%2Fmessages_en.properties),
[messages_es.properties](src%2Fmain%2Fresources%2Fmessages_es.properties),
[messages_ru.properties](src%2Fmain%2Fresources%2Fmessages_ru.properties)