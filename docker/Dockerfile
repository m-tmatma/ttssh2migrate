FROM lightraven/svn-all-fast-export
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing && apt-get dist-upgrade -y && apt-get autoremove --purge -y \
 && apt-get install --fix-missing -y \
     locales \
     gosu \
 && rm -rf /var/lib/apt/lists/*

# Locales
RUN dpkg-reconfigure locales \
 && locale-gen en_US.UTF-8 \
 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LC_ALL   en_US.UTF-8
ENV LANG     en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
