FROM yasuyuky/rust-ssl-static as build

COPY ./ ./

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install libssl-dev

RUN make build-static-release

RUN mkdir -p /build-out

RUN cp target/x86_64-unknown-linux-musl/release/totto /build-out/

RUN ls /build-out/

FROM scratch

COPY --from=build /build-out/totto /

ENTRYPOINT ["/totto"]
