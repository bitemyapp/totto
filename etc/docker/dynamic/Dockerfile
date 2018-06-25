FROM rust:latest as build

COPY ./ ./

RUN make build-dynamic-release

RUN mkdir -p /build-out

RUN cp target/x86_64-unknown-linux-musl/release/totto /build-out/

RUN ls /build-out/

FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install libssl-dev

COPY --from=build /build-out/totto /

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
