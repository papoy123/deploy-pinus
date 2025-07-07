# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json package-lock.json* ./
RUN npm ci

# Stage 2: Builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Uncomment the following line in case you want to disable telemetry during the build.
ENV NEXT_TELEMETRY_DISABLED 1

RUN npm run buildwendra@wendra-Swift-SFX14-41G:~/wendra-deploy/deploy5-pinus$ aja deploy
🚀 Deploying pinuspintar-app...
✓ Deployment initiated successfully
URL: https://pinuspintar-app.deployaja.id
🔍 Waiting for deployment to complete...
📊 Status: deploying
⚠️ Warning: Failed to monitor deployment status: API error: 
💡 You can check the status manually using: deployaja status
wendra@wendra-Swift-SFX14-41G:~/wendra-deploy/deploy5-pinus$ 

# Stage 3: Runner
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 8070

ENV PORT 8070
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"] 
