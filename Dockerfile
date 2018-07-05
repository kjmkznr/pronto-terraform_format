FROM ruby:2.5-alpine

RUN apk add --no-cache --virtual .builddeps make cmake musl-dev gcc \
 && gem install --no-document pronto-terraform_format \
 && apk del .builddeps

ENV TERRAFORM_VERSION=0.11.7

RUN apk --update add ca-certificates curl
RUN curl -LOs https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin/
RUN rm -rf /var/cache/apk/* terraform_${TERRAFORM_VERSION}_linux_amd64.zip

ENTRYPOINT ["pronto"]
