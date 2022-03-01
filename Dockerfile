FROM python:3.9-alpine

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.0.0

RUN apk add --virtual .build-deps make g++ python3-dev libffi-dev openssl-dev
RUN pip3 install poetry
RUN poetry config virtualenvs.create false
# RUN poetry install --no-dev

RUN mkdir /sampleApp/
WORKDIR /sampleApp/
COPY . /sampleApp/


CMD make install && make run
