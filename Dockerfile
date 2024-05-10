# we have to use amd64 because that's what the Obsidian deb's architecture is
FROM amd64/ubuntu

RUN apt-get update && apt-get install -y \
    xterm \
    x11vnc \
    xvfb \
    wget \
    libgtk-3-0 \
    libnotify4 \
    libnss3 \
    xdg-utils \
    libatspi2.0-0 \
    libsecret-1-0 \
    libgbm-dev \
    libasound-dev \
    xdotool \
    imagemagick \
    tesseract-ocr \
    rsync \
    && rm -rf /var/lib/apt/lists/*

ARG OBSIDIAN_URL
RUN if [ -z "$OBSIDIAN_URL" ]; then echo "OBSIDIAN_URL is not set" && exit 1; fi; \
    wget $OBSIDIAN_URL  \
    && dpkg -i *.deb \
    && rm *.deb 

COPY startup startup
CMD ["./startup"]
