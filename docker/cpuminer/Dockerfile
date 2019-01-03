FROM watcoin:argon2
# Install extra tools
RUN apt-get update && \
    apt-get install -y curl vim wget && \
    rm -rf /var/lib/apt/lists/*
# Install basic dependencies
RUN apt-get update && \
    apt-get install -y automake gcc libcurl4-openssl-dev make python3 && \
    rm -rf /var/lib/apt/lists/*
# Copy whole source
COPY ./cpuminer/ /cpuminer
# Change workdir
WORKDIR /cpuminer
# Configure solution
RUN ./autogen.sh && \
    ./configure CFLAGS="-O3"
# Make solution
RUN make
# Install solution
RUN make install
# Change entrypoint
COPY ./bin/docker/docker-cpuminer-entrypoint.sh /docker-cpuminer-entrypoint.sh
ENTRYPOINT ["/docker-cpuminer-entrypoint.sh"]
