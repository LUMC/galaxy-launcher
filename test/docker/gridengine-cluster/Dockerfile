FROM lumc/ubuntu-gridengine-drmaa

EXPOSE 6444
EXPOSE 6445
RUN apt-get upgrade && apt-get install python
RUN useradd -d /home/galaxy --create-home --uid 1450 galaxy

CMD ["sleep","10000000"]
