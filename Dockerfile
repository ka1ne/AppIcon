FROM swift:latest as builder

WORKDIR /app
COPY Package.swift .
COPY Sources ./Sources
COPY Tests ./Tests
RUN apt-get update && apt-get install -y libgd-dev libjpeg-dev libpng-dev make
RUN make install

ENTRYPOINT ["appicon"]