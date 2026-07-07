# Download dependencies
FROM python:3.11-slim AS builder
RUN apt-get update && apt-get upgrade -y
WORKDIR /app

# Upgrade the internal base image utilities to patch internal CVEs
RUN pip install --no-cache-dir --upgrade pip setuptools wheel jaraco.context

COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Alpine Linux for minimal runtime
FROM python:3.11-alpine
RUN apk update && apk upgrade
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app

# Pull only compiled dependencies
COPY --from=builder /root/.local /home/appuser/.local
COPY . /app

# Update paths and switch away from Root user privileges
ENV PATH=/home/appuser/.local/bin:$PATH
USER appuser
EXPOSE 8080
ENTRYPOINT ["python3", "app.py"]