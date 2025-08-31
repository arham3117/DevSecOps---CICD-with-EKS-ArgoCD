#------------- STAGE 1: Build the application -------------

FROM maven:3.8.6-openjdk-17 AS build

WORKDIR /app

COPY . .

RUN mvn clean install package -DskipTests=true

#------------- STAGE 2: Create the final image -------------
FROM openjdk:17-jdk-slim AS runtime

WORKDIR /app

COPY --from=build /app/target/*.jar /app/target/BankApp.jar

EXPOSE 8080

CMD ["java", "-jar", "/app/target/BankApp.jar"]

#------------- End of Dockerfile -------------