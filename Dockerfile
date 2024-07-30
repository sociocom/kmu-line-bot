FROM debian:stable
SHELL ["/bin/bash", "-c"]
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# この二行をまとめたいが、何故かこう書かないととコケる……
RUN apt-get update && apt-get install -y curl
RUN apt-get install -y --no-install-recommends build-essential

RUN curl -sSfL https://rye-up.com/get | RYE_NO_AUTO_INSTALL=1 RYE_INSTALL_OPTION="--yes" bash
ENV PATH $PATH:/root/.rye/shims

WORKDIR /bot
COPY .python-version pyproject.toml /bot/

RUN rye sync

COPY main.py fqa_service.py .env data/ /bot/

EXPOSE 7070
