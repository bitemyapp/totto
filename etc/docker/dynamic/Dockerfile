FROM rust@sha256:1cdce1c7208150f065dac04b580ab8363a03cff7ddb745ddc2659d58dbc12ea8 as build

COPY ./ ./

RUN make build-dynamic-release

RUN mkdir -p /build-out

RUN cp target/release/totto /build-out/

RUN ls /build-out/

FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install libssl-dev

COPY --from=build /build-out/totto /

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
