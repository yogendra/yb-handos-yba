FROM vault:1.13.3

RUN apk add jq

ADD config/* /vault/config/
ADD vault-start.sh /bin/vault-start.sh
ENTRYPOINT [ "/bin/vault-start.sh" ]
