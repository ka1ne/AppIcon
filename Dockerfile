FROM swift:latest

# Set the working directory inside the container
WORKDIR /app

# Copy the necessary files from your local directory to the container
COPY Package.swift .
COPY Makefile .
COPY Sources ./Sources
COPY Tests ./Tests

# Install system dependencies for the build
RUN apt-get update && apt-get install -y libgd-dev libjpeg-dev libpng-dev make

# Run Swift build and then install
RUN make install

# Create a wrapper script
RUN echo '#!/bin/bash\n\
echo "=== Input Arguments ==="\n\
echo "Arguments received: $@"\n\
echo "====================="\n\
appicon "$@"' > /usr/local/bin/wrapper.sh && \
    chmod +x /usr/local/bin/wrapper.sh

# Use the wrapper script as the entry point
ENTRYPOINT ["/usr/local/bin/wrapper.sh"]