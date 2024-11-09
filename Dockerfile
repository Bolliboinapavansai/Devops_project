# Stage 1: Build stage
FROM python:3.9-slim AS build

# Set the working directory
WORKDIR /app

# Install system dependencies required for Django
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file first and install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final stage (minimal image)
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app /app

# Copy your project files into the container
COPY . /app/

# Expose the port Django runs on
EXPOSE 8000

# Run database migrations
RUN python manage.py migrate

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
