FROM alpine:latest
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache openssh sshpass
#COPY --chmod=755 upload.sh /app/upload.sh
#COPY known_hosts /app/known_hosts
#COPY --chmod=600 id_rsa.pub /app/medis-etl-ssh-key
WORKDIR /tmp/share
CMD /app/upload.sh
