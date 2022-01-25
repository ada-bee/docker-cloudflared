FROM golang:1.17.1 AS build

ARG VERSION

WORKDIR /go/src/
RUN wget https://github.com/cloudflare/cloudflared/archive/refs/tags/${VERSION}.tar.gz && tar -xvf ${VERSION}.tar.gz && mv cloudflared-${VERSION} cloudflared

WORKDIR /go/src/cloudflared
RUN make cloudflared


FROM gcr.io/distroless/base-debian10:nonroot

COPY --from=build --chown=nonroot /go/src/cloudflared/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]