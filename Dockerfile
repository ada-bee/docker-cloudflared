FROM golang AS build

ARG VERSION

WORKDIR /go/src/
RUN wget https://github.com/cloudflare/cloudflared/archive/refs/tags/${VERSION}.tar.gz && tar -xvf ${VERSION}.tar.gz && mv cloudflared-${VERSION} cloudflared

ENV GO111MODULE=on
ENV CGO_ENABLED=0

WORKDIR /go/src/cloudflared
RUN make cloudflared


FROM gcr.io/distroless/base

COPY --from=build /go/src/cloudflared/cloudflared /bin/cloudflared

ENTRYPOINT ["/bin/cloudflared", "--no-autoupdate"]
CMD ["version"]