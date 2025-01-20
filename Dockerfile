FROM swift:latest as builder

WORKDIR /app
COPY Package.swift .
COPY Sources ./Sources
COPY Tests ./Tests
RUN apt-get update && apt-get install -y libgd-dev libjpeg-dev libpng-dev
RUN swift build -c release --static-swift-stdlib

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libgd3 libjpeg-turbo8 libpng16-16 && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/.build/release/appicon /usr/local/bin/appicon
ENTRYPOINT ["appicon"]
