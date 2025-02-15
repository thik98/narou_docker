FROM ruby:latest
ENV LANG=ja_JP.UTF-8
ENV AOZORA_EPUB3_FILE=AozoraEpub3-1.1.1b30Q.zip
ENV KINDLEGEN_FILE=kindlegen_linux_2.6_i386_v2_9.tar.gz
ENV NAROU_VERSION=3.9.1

WORKDIR /opt/narou

RUN apt-get update && \
    apt-get install -y locales && \
    echo "ja_JP UTF-8" > /etc/locale.gen && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8 && \
    apt-get install -y --no-install-recommends \
      build-essential \
      unzip wget curl && \
    rm -rf /var/lib/apt/lists/*

COPY ${AOZORA_EPUB3_FILE} /tmp
COPY ${KINDLEGEN_FILE} /tmp
COPY init.sh /usr/local/bin

RUN unzip /tmp/${AOZORA_EPUB3_FILE} -d /opt/AozoraEpub3 && \
    rm /tmp/${AOZORA_EPUB3_FILE}

RUN mkdir -p /opt/kindlegen && \
    tar zxf /tmp/${KINDLEGEN_FILE} -C /opt/kindlegen && \
    ln -s /opt/kindlegen/kindlegen /opt/AozoraEpub3 && \
    rm /tmp/${KINDLEGEN_FILE}

RUN curl -LO https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-x64_bin.tar.gz && \
    tar xzf openjdk-23.0.2_linux-x64_bin.tar.gz -C /usr/local
    
ENV PATH="/usr/local/jdk-23.0.2/bin:${PATH}"
ENV JAVA_HOME="/usr/local/jdk-23.0.2"

RUN gem install tilt -v 2.3.0 && \
    gem install narou -v ${NAROU_VERSION} --no-document

ENTRYPOINT ["init.sh"]
CMD ["narou", "web", "-p", "8200", "-n"]
