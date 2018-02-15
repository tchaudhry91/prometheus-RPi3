FROM hypriot/rpi-alpine
LABEL maintainer "Tanmay Chaudhry <tanmay.chaudhry@gmail.com>"

RUN apk update && \
    apk upgrade && \
    apk add bash ca-certificates && \
    rm -rf /var/cache/apk/*

COPY bins/prometheus /bin/prometheus
COPY bins/promtool /bin/promtool
COPY prometheus/documentation/examples/prometheus.yml /etc/prometheus/prometheus.yml
COPY prometheus/console_libraries/ /usr/share/prometheus/console_libraries
COPY prometheus/consoles/ /usr/share/prometheus/consoles/

RUN ln -s /usr/share/prometheus/console_libraries /usr/share/prometheus/consoles/ /etc/prometheus/

RUN mkdir -p /prometheus && \
    chown -R nobody:nogroup etc/prometheus /prometheus

USER       nobody
EXPOSE     9090
VOLUME     [ "/prometheus" ]
WORKDIR    /prometheus
ENTRYPOINT [ "/bin/prometheus" ]
CMD        [ "--config.file=/etc/prometheus/prometheus.yml", \
             "--storage.tsdb.path=/prometheus", \
             "--web.console.libraries=/usr/share/prometheus/console_libraries", \
             "--web.console.templates=/usr/share/prometheus/consoles" ]
