# Use simple Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install Great Expectations (Pinned Version for Compatibility)
RUN pip install --no-cache-dir great_expectations==0.18.21 sqlalchemy psycopg2-binary

# Keep container running efficiently
CMD ["tail", "-f", "/dev/null"]