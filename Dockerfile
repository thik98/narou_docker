FROM ruby:3.0.6
ENV LANG ja_JP.UTF-8
ENV AOZORA_EPUB3_FILE AozoraEpub3-1.1.1b14Q2.zip
ENV KINDLEGEN_FILE kindlegen_linux_2.6_i386_v2_9.tar.gz
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
    cd /tmp && \
    wget https://github.com/rogenobl/narou/releases/download/p0.4/pagination_with_fix.zip && \
    wget https://github.com/rogenobl/narou/releases/download/v0.2/sitesettinghandler.zip

COPY ${AOZORA_EPUB3_FILE} /tmp
COPY ${KINDLEGEN_FILE} /tmp
COPY init.sh /usr/local/bin

RUN unzip /tmp/${AOZORA_EPUB3_FILE} -d /opt/AozoraEpub3 && \
    rm /tmp/${AOZORA_EPUB3_FILE}

RUN mkdir -p /opt/kindlegen && \
    tar zxf /tmp/${KINDLEGEN_FILE} -C /opt/kindlegen && \
    ln -s /opt/kindlegen/kindlegen /opt/AozoraEpub3 && \
    rm /tmp/${KINDLEGEN_FILE}

RUN gem install narou -v ${NAROU_VERSION} --no-document

RUN (echo ; cat /usr/local/bundle/gems/narou-${NAROU_VERSION}/preset/custom_chuki_tag.txt) >> /opt/AozoraEpub3/chuki_tag.txt

RUN cd /tmp && \
    unzip /tmp/pagination_with_fix.zip && \
    unzip /tmp/sitesettinghandler.zip && \
    cp -rf /tmp/pagination_with_fix/* /usr/local/bundle/gems/narou-3.8.2/ && \
    cp -rf /tmp/sitesettinghandler/* /usr/local/bundle/gems/narou-3.8.2/ && \
    rm -rf /tmp/pagination_with_fix && \
    rm -fr /tmp/sitesettinghandler && \
    rm -fr /tmp/pagination_with_fix.zip && \
    rm -fr /tmp/sitesettinghandler.zip

COPY ext.patch /usr/local/bundle/gems/narou-3.8.2/lib/
RUN cd /usr/local/bundle/gems/narou-3.8.2/lib/ && \
    patch < ext.patch

ENTRYPOINT ["init.sh"]
CMD ["narou", "web", "-p", "8200", "-n"]
