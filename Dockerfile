FROM python:3.11.1

WORKDIR /opt/grepmarx

ENV FLASK_APP run.py

RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/log/supervisor
COPY supervisord-docker.conf /etc/supervisor/conf.d/supervisord.conf

COPY entrypoint.sh run.py gunicorn-cfg.py requirements.txt requirements-pgsql.txt ./
COPY .env-docker .env
COPY nginx nginx
COPY app app
COPY migrations migrations
RUN mkdir data

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements-pgsql.txt

EXPOSE 5000

RUN chmod u+x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]