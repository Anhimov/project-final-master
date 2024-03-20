FROM amazoncorretto:17-alpine
WORKDIR /app
ARG SOURCE_JAR=target/*.jar
COPY ${SOURCE_JAR} /app/
COPY resources /app/resources
ENTRYPOINT ["java", "-jar", "/app/jira-1.0.jar"]