FROM lumc/ubuntu-gridengine-drmaa

EXPOSE 6444
EXPOSE 6445
RUN apt-get update && apt-get install -y --no-install-recommends python=2.7
RUN useradd -d /home/galaxy --create-home --uid 1450 galaxy

CMD ["sleep","10000000"]
