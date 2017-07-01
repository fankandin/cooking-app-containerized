FROM vintagedreamer/cooking-app-api
COPY env.properties /app/env.properties
CMD ["java", "-Xmx512m", "-Xss256k", "-jar", "/app/cooking-app-api.jar", "--spring.config.location=/app/env.properties", "--spring.profiles.active=production", "--spring.cors.origins=http://api.palamarchuk.info.dev:8081"]