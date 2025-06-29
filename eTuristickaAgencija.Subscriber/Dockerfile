FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["eTuristickaAgencija.Subscriber/eTuristickaAgencija.Subscriber.csproj", "eTuristickaAgencija.Subscriber/"]
RUN dotnet restore "eTuristickaAgencija.Subscriber/eTuristickaAgencija.Subscriber.csproj"
COPY . .
WORKDIR "/src/eTuristickaAgencija.Subscriber"
RUN dotnet build "eTuristickaAgencija.Subscriber.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "eTuristickaAgencija.Subscriber.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "eTuristickaAgencija.Subscriber.dll"]