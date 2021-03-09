# pull official base image
FROM node:15.4-alpine

# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# update and upgrade alpine packages
RUN apk update && apk upgrade

# install python3
RUN apk add --no-cache python3 \
    && ln -s /usr/bin/python3 /bin/python \
    && ln -s /usr/bin/pip3 /bin/pip \
    && python -m ensurepip \
    && pip install --upgrade pip

WORKDIR /app
COPY ./app /app
COPY ./requirements.txt /app
COPY ./package.json /app

# install python dependencies
RUN pip install -r requirements.txt

# install node packages
RUN npm install

RUN python manage.py makemigrations
RUN python manage.py migrate

### Developement
RUN adduser -D myuser
USER myuser

### Production Deployment
# RUN mkdir -p /vol/web/static
# RUN adduser -D myuser
# RUN chown -R myuser:myuser /vol/
# RUN chmod -R 755 /vol/web
# USER myuser