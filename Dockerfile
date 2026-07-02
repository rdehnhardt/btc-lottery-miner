# O cpuminer-linux é um binário x86-64: o host precisa ser amd64
# (ou usar emulação: docker build --platform linux/amd64)
FROM node:20-slim

# procps: pgrep/pkill usados pelo watchdog do server.js
# tini: PID 1 que faz reap dos processos do minerador
RUN apt-get update \
    && apt-get install -y --no-install-recommends procps tini \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY server.js ./
COPY public ./public
COPY miner/cpuminer-linux ./miner/cpuminer-linux
RUN chmod +x miner/cpuminer-linux && mkdir -p /data

ENV NODE_ENV=production \
    DATA_DIR=/data \
    PORT=3500

VOLUME /data
EXPOSE 3500

ENTRYPOINT ["tini", "--"]
CMD ["node", "server.js"]
