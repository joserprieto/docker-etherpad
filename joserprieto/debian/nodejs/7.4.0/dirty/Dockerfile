FROM joserprieto/nodejs:7.4.0-es-es

MAINTAINER joserprieto "talktome@joserprieto.es"

RUN set -x \
	&& apt-get update \
	&& apt-get install -y gzip git curl python libssl-dev \
	&& rm -r /var/lib/apt/lists/*

RUN set -x \
	&& cd /opt \
    && git clone https://github.com/ether/etherpad-lite etherpad \
    && cd etherpad \
    && bin/installDeps.sh \
    && rm settings.json \
    && apt-get purge -y --auto-remove git

COPY entrypoint.sh /entrypoint.sh

VOLUME /opt/etherpad/var

RUN ln -s /opt/etherpad/var/settings.json /opt/etherpad/settings.json

WORKDIR /opt/etherpad

EXPOSE 9001

ENTRYPOINT ["/entrypoint.sh"]

CMD ["bin/run.sh", "--root"]