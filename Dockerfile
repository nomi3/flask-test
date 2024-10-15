FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --system nginx && adduser --system --no-create-home --disabled-login --group nginx

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY uwsgi.ini /app/uwsgi.ini


RUN rm -rf /etc/nginx/sites-enabled/default
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["/usr/bin/supervisord"]

