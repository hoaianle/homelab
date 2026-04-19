FROM alpine:latest

RUN apk add --no-cache vsftpd

COPY entrypoint.sh /bin/entrypoint.sh
COPY config/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]