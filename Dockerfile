FROM python:2.7
MAINTAINER Shannon Black <shannon@ilovezoona.com>

RUN apt-get update && apt-get install -qq -y telnetd
RUN apt-get install -qq -y telnet
RUN apt-get install -y dos2unix

# configure entrypoint 
# [dos2unix to a robust cross-OS image]
COPY ./docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh
RUN dos2unix /docker-entrypoint.sh

# copy the whole project 
COPY ./ /jasminwebpanel
WORKDIR /jasminwebpanel
RUN cd /jasminwebpanel/ && find . -type f -print0 | xargs -0 dos2unix

RUN pip install psycopg2
RUN pip install -r requirements.pip

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ./manage.py runserver 0.0.0.0:8000
