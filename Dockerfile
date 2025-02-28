ARG ARCH=amd64
ARG PLATFORM=linux
FROM alpine as fetcher

ARG VERSION
ARG ARCH
ARG PLATFORM

RUN apk --update add openssl wget unzip
WORKDIR /tmp
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${VERSION}/pocketbase_${VERSION}_${PLATFORM}_${ARCH}.zip && \
    unzip pocketbase_${VERSION}_${PLATFORM}_${ARCH}.zip

######

FROM gcr.io/distroless/static

COPY --from=fetcher /tmp/pocketbase /pocketbase/pocketbase
ENTRYPOINT [ "/pocketbase/pocketbase" ]
CMD [ "serve", "--http", "0.0.0.0:8090" ]
