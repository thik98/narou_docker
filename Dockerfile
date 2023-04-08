FROM ruby:latest
ENV LANG ja_JP.UTF-8
ENV NAROU_VERSION 3.8.2
WORKDIR /opt/narou

RUN apt-get update && \
    apt-get install -y locales && \
    echo "ja_JP UTF-8" > /etc/locale.gen && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8 && \
    apt-get install -y --no-install-recommends \
      default-jdk \
      build-essential \
      unzip wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/kyukyunyorituryo/AozoraEpub3/releases/download/v1.1.1b14Q/AozoraEpub3-1.1.1b14Q.zip -O /tmp/AozoraEpub3-1.1.1b14Q.zip && \
    wget https://github.com/zzet/fp-docker/raw/master/kindlegen_linux_2.6_i386_v2_9.tar.gz -O /tmp/kindlegen_linux_2.6_i386_v2_9.tar.gz

RUN unzip /tmp/AozoraEpub3-1.1.1b14Q.zip && \
    mv AozoraEpub3-1.1.1b14Q /opt/AozoraEpub3 && \
    rm /tmp/AozoraEpub3-1.1.1b14Q.zip

RUN mkdir -p /opt/kindlegen && \
    tar zxf /tmp/kindlegen_linux_2.6_i386_v2_9.tar.gz -C /opt/kindlegen && \
    ln -s /opt/kindlegen/kindlegen /opt/AozoraEpub3 && \
    rm /tmp/kindlegen_linux_2.6_i386_v2_9.tar.gz

RUN gem install narou -v ${NAROU_VERSION}

RUN (echo ; cat /usr/local/bundle/gems/narou-${NAROU_VERSION}/preset/custom_chuki_tag.txt) >> /opt/AozoraEpub3/chuki_tag.txt

COPY init.sh /usr/local/bin

ENTRYPOINT ["init.sh"]
CMD ["narou", "web", "-p", "8200", "-n"]
