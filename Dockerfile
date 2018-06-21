FROM rust:latest as build

COPY ./ ./

RUN make build-release

RUN cp target/release/totto /build-out/

RUN ls /build-out/

# FROM scratch
FROM alpine:latest  

COPY --from=build /build-out/totto /

RUN ls -l /

RUN ls -l /totto

RUN chmod +x /totto

RUN ls -l /totto

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
