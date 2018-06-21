# FROM rust:latest as build
# FROM ekidd/rust-musl-builder:latest as build
FROM yasuyuky/rust-ssl-static as build

COPY ./ ./

RUN make build-static-release

RUN mkdir -p /build-out

RUN cp target/x86_64-unknown-linux-musl/release/totto /build-out/

RUN ls /build-out/

# RUN ldd /build-out/totto

FROM scratch
# FROM alpine:latest
# FROM ubuntu:18.04

# RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install libssl-dev

COPY --from=build /build-out/totto /

# RUN ls -l /

# RUN ls -l /totto

# RUN chmod +x /totto

# RUN ls -l /totto

ENTRYPOINT ["/totto"]

# COPY ./docker-entrypoint.sh /

# RUN chmod +x /docker-entrypoint.sh

# ENTRYPOINT ["/docker-entrypoint.sh"]
