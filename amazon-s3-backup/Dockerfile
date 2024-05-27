ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# add aws-cli
RUN apk add -v --update --no-cache \
        # python3 \
        # py3-pip \
        # groff \
        less \
        aws-cli
    #     && \
    # pip3 install --upgrade awscli

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
