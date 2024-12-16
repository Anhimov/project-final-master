## [REST API Documentation](http://localhost:8080/doc)

## Concept:

- **Spring Modulith**
  - [Spring Modulith: Have We Achieved Modularity Maturity?](https://habr.com/ru/post/701984/)
  - [Introducing Spring Modulith](https://spring.io/blog/2022/10/21/introducing-spring-modulith)
  - [Spring Modulith - Reference Documentation](https://docs.spring.io/spring-modulith/docs/current-SNAPSHOT/reference/html/)

```
  url: jdbc:postgresql://localhost:5432/jira
  username: jira
  password: JiraRush
```

- There are two shared tables without foreign keys:
  - **Reference**: A reference table. Relationships are made using the `code` column (not `id` because `id` is environment-specific).
  - **UserBelong**: Links users with types (owner, lead, etc.) to objects (task, project, sprint, etc.). Foreign keys are manually validated.

## Alternatives

- [Open Source Issue Trackers](https://java-source.net/open-source/issue-trackers)

## Testing

- [How to Write Tests](https://habr.com/ru/articles/259055/)

## Completed Tasks:

### 2. Remove social networks: VK and Yandex.

### 3. Extract sensitive information to a separate property file:
#### Files created:
- [application-sensitive.yaml](src/main/resources/application-sensitive.yaml)
- [.env](.env)
#### To run the application in the IDE, pass the `.env` file in the Environment variables configuration.

### 4. Use an in-memory database (H2) for testing:
- Created the file [application-testH2.yaml](src/test/resources/application-testH2.yaml).
- Renamed [application-testPostgres.yaml](src/test/resources/application-testPostgres.yaml).
- In [BaseTests.java](src/test/java/com/javarush/jira/BaseTests.java), specify the test database profile: `testH2` or `testPostgres`.
- In [AbstractControllerTest.java](src/test/java/com/javarush/jira/AbstractControllerTest.java), change the script used for testing.

### 5. Write tests for all public methods in `ProfileRestController`:
- Tests are written in [ProfileRestControllerTest.java](src/test/java/com/javarush/jira/profile/internal/web/ProfileRestControllerTest.java).

### 6. Refactor the method `com.javarush.jira.bugtracking.attachment.FileUtil#upload`:
- Refactored in [FileUtil.java](src/main/java/com/javarush/jira/bugtracking/attachment/FileUtil.java).
- Used `Path` and `Files` classes.

### 8. Add time tracking for tasks in progress and testing:
- Added two methods to [TaskService.java](src/main/java/com/javarush/jira/bugtracking/task/TaskService.java).
- Added a method in the repository [ActivityRepository.java](src/main/java/com/javarush/jira/bugtracking/task/ActivityRepository.java).
- Updated the SQL script [changelog.sql](src/main/resources/db/changelog.sql) to include new rows in the table. However, this was later commented out in step 10 as it caused issues with `docker-compose up`.

### 9. Write a Dockerfile for the main server:
- Created [Dockerfile](Dockerfile).

### 10. Write a `docker-compose` file to run the server container with the database and Nginx:
- Created [docker-compose.yaml](docker-compose.yaml).
- Updated [nginx.conf](config/nginx.conf).
- For Docker version 4.27.1, upgrade to version 4.28.0 (e.g., Docker Desktop for Windows) to avoid this issue: [Stack Overflow](https://stackoverflow.com/questions/77993212/docker-compose-build-failed-to-solve-changes-out-of-order).
- The project runs but has the following issues:
  - Header displays incorrectly (likely due to incomplete language template implementation).
  - Swagger works but fails authentication.

### 11. Add localization for at least two languages for email templates and the `index.html` page:
- Updated template files to use variables: [password-reset.html](resources/mails/password-reset.html), [email-confirmation.html](resources/mails/email-confirmation.html), and [index.html](resources/view/index.html).
- Created the `Resource Bundle 'messages'` folder with language files for English, Russian, and Spanish:
  - [messages_en.properties](src/main/resources/messages_en.properties)
  - [messages_es.properties](src/main/resources/messages_es.properties)
  - [messages_ru.properties](src/main/resources/messages_ru.properties)

## Running the Application

### Prerequisites
1. Install Docker and Docker Compose.
2. Ensure the following environment variables are defined in a `.env` file:
   ```env
   DB_USERNAME=your_database_username
   DB_PASSWORD=your_database_password
   ```

### Steps to Run the Application
1. Build the Docker image:
   ```bash
   docker build -t jira-app .
   ```

2. Start the application using Docker Compose:
   ```bash
   docker-compose up
   ```

3. Access the application:
  - Application: [http://localhost:8080](http://localhost:8080)
  - API Documentation: [http://localhost:8080/doc](http://localhost:8080/doc)

### Notes
- If using a version of Docker older than 4.28.0, upgrade to avoid compatibility issues.
- To troubleshoot issues, refer to container logs:
   ```bash
   docker logs jira-app
   ```

