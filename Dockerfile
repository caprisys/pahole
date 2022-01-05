FROM alpine:latest AS builder

RUN apk add --no-cache \
    cmake \
    make \
    gcc \
    musl-dev \
    libdwarf-dev \
    libdwarf-static \
    libelf \
    elfutils-dev \
    libelf-static \
    git \
    linux-headers \
    musl-obstack-dev \
    argp-standalone

WORKDIR /source

RUN git clone https://git.kernel.org/pub/scm/devel/pahole/pahole.git

RUN cd pahole && \
    mkdir build && \
    cd build && \
    cmake -D__LIB=lib -DBUILD_SHARED_LIBS=OFF .. && \
    make install

FROM alpine:latest

RUN apk add --no-cache \
    libdwarf \
    musl-obstack                    

COPY --from=builder /usr/local /usr/local
