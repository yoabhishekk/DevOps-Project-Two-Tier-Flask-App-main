# Use a modern, supported Python runtime
FROM python:3.14-slim

# Set the working directory
WORKDIR /app

# Install system dependencies, install python packages, then clean up build tools
# (Grouping this saves space and removes the compiler from the final image)
COPY requirements.txt .
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    pkg-config \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get purge -y --auto-remove gcc pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
