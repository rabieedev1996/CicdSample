FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 8080


FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["CICDSample/CICDSample.csproj", "CICDSample/"]
RUN dotnet restore "CICDSample/CICDSample.csproj"
COPY . .
WORKDIR "/src/CICDSample"
RUN dotnet build "CICDSample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CICDSample.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CICDSample.dll"]
