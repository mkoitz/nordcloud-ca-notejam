FROM openjdk:8-jdk-alpine
# use JBoss or Tomcat for production and not Jetty
COPY target/spring-*.jar spring.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/spring.jar"]