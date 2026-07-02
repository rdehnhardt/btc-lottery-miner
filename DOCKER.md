# Deploy com Docker / Dokploy

## Requisitos

- Host **amd64** (x86-64). O `miner/cpuminer-linux` é um binário x86-64 — em
  Apple Silicon só roda com emulação (`--platform linux/amd64`), e em VPS ARM
  não roda.

## Rodando local

```bash
cp .env.example .env   # preencha WALLET
docker compose up -d --build
# painel: http://localhost:3500
```

## Deploy no Dokploy

1. Crie uma **Application** apontando para este repositório (branch `feat/docker`).
2. Build type: **Dockerfile** (ou use o `docker-compose.yml` como Compose).
3. Configure as variáveis de ambiente:
   - `WALLET` — sua carteira BTC (**obrigatória**: o painel web não permite
     configurar a wallet remotamente, por segurança)
   - `POWER` — % de threads da CPU (1-100, padrão 50)
4. Porta do container: **3500**.
5. Monte um volume em `/data` para persistir o `stats.json` (opcional — a
   wallet vem do env de qualquer forma).

## Segurança

- As rotas de configuração (`/api/setup/*`) só aceitam requisições de
  `localhost`. Atrás do proxy do Dokploy elas ficam bloqueadas de propósito —
  se fossem abertas, qualquer visitante poderia trocar a wallet pela dele.
  Toda configuração em produção é via variáveis de ambiente.
- O minerador usa CPU de verdade. Controle o consumo com `POWER` e/ou um
  limite de CPU no container (`cpus:` no compose ou limite no Dokploy).

## Verificação

Com o container no ar, confira o worker em
`https://web.public-pool.io/#/app/SUA_WALLET`.
