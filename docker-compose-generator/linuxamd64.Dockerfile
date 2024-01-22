#
FROM mcr.microsoft.com/dotnet/sdk:8.0.100-bookworm-slim AS builder
WORKDIR /source
COPY src/docker-compose-generator.csproj docker-compose-generator.csproj
COPY app/crypto-definitions.json crypto-definitions.json 
# Cache some dependencies
RUN dotnet restore
COPY src/. .
RUN dotnet publish --output /app/ --configuration Release
#
FROM mcr.microsoft.com/dotnet/runtime:8.0.0-bookworm-slim
LABEL org.btcpayserver.image=docker-compose-generator
WORKDIR /datadir
WORKDIR /app
ENV APP_DATADIR=/datadir
VOLUME /datadir

ENV INSIDE_CONTAINER=1

COPY --from=builder "/app" .

ENTRYPOINT ["dotnet", "docker-compose-generator.dll"]
