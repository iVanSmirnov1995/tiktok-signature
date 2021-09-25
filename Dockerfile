#tiktok-signature
FROM ubuntu:bionic AS tiktok_signature.build

WORKDIR /usr

# 1. Install node12
RUN apt-get update && apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g pm2


RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn
RUN yarn install


RUN PLAYWRIGHT_BROWSERS_PATH=/usr/lib/playwright yarn add playwright-chromium@1.11.1

RUN PLAYWRIGHT_BROWSERS_PATH=/usr/lib/playwright yarn add playwright-webkit@1.11.1

RUN PLAYWRIGHT_BROWSERS_PATH=/usr/lib/playwright yarn add playwright-firefox@1.11.1

# 5. Copying required files

ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm i
ADD . .

EXPOSE 8080
CMD [ "pm2-runtime", "listen.js" ]
