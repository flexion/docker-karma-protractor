#
FROM muccg/python-base:debian8-2.7
MAINTAINER ccg <devops@ccg.murdoch.edu.au>

RUN apt-get update && apt-get install -y --no-install-recommends \
  npm nodejs nodejs-legacy iceweasel xvfb && \
  apt-get autoremove -y --purge && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN npm install -g inherits \
  && npm install -g \
  jasmine-node \
  jasmine-reporters@1.0.0 \
  protractor-linkuisref-locator \
  karma \
  karma-firefox-launcher \
  karma-jasmine \
  karma-junit-reporter \
  karma-ng-scenario

ENV NODE_PATH /usr/lib/nodejs/:/usr/local/lib/node_modules/
ENV PATH /usr/local/firefox:/usr/lib/node_modules/bin:/usr/bin:/bin

VOLUME ["/data"]

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD /docker-entrypoint.sh
