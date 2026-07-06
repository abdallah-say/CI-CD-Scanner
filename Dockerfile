# Download dependencies
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Alpine Linux for minimal runtime
FROM python:3.11-alpine
RUN addgroup -S appgroup ** adduser -S appuser -G appgroup
WORKDIR /app

# Pull only compiled dependencies
COPY --from=builder /root/.local /home/appuser/.local
COPY . /app

# Update paths and switch away from Root user privileges
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser
EXPOSE 8080
ENTRYPOINT ["python3", "app.py"]