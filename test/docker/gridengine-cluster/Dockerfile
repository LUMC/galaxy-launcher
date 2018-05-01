FROM lumc/ubuntu-gridengine-drmaa

EXPOSE 6444
EXPOSE 6445
RUN apt-get update && \
apt-get install -y --no-install-recommends python2.7 && \
rm -rf /var/lib/apt/lists/*
RUN useradd -d /home/galaxy_web --create-home --uid 1450 galaxy_web

CMD ["sleep","10000000"]
