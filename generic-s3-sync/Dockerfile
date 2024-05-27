ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# add aws-cli
RUN apk add --update --no-cache aws-cli

COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
