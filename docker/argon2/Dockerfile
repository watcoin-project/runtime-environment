FROM ubuntu:18.04
# Install build tools
RUN apt-get update && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*
# Copy whole source
COPY argon2/ /argon2
# Make solution
RUN make --directory /argon2
# Install solution
RUN make --directory /argon2 install
# Cleanup
RUN rm -rf /argon2
