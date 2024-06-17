# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Install necessary dependencies
RUN pip install prowler

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Give execution permissions to the entrypoint script
RUN chmod +x /entrypoint.sh

# Define the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

