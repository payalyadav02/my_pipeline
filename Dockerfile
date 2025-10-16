# Dockerfile
FROM python:3.11-slim
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Collect static files and run migrations for Django
RUN python manage.py collectstatic --noinput || true
RUN python manage.py migrate || true

# Expose FastAPI and Django ports
ENV PORT=8000
EXPOSE 8000
EXPOSE 8080

# Start both FastAPI and Django using a process manager
CMD ["sh", "-c", "uvicorn cicd.main:app --host 0.0.0.0 --port 8000 & python manage.py runserver 0.0.0.0:8080"]
