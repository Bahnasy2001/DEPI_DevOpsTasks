# Stage 1: Build the application
FROM eclipse-temurin:latest AS builder

WORKDIR /app

COPY . .

# EXPOSE 8080

RUN ./mvnw package

# Stage 2: Development Environment
FROM eclipse-temurin:latest AS dev

WORKDIR /app

COPY --from=builder /app/target .

EXPOSE 8080

CMD ["/bin/sh", "-c", "java -jar *.jar"]


# Stage 3: Production Environment
FROM eclipse-temurin:latest AS prod

WORKDIR /app

COPY --from=builder /app/target .

EXPOSE 8080

CMD ["/bin/sh", "-c", "java -jar *.jar"]

