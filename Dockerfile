FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app

COPY docker-debugger.csproj ./myapp/
RUN dotnet restore ./myapp/docker-debugger.csproj

COPY . ./myapp/
WORKDIR /app/myapp
RUN dotnet publish -c Debug -o out

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:7000
EXPOSE 7000
COPY --from=build /app/myapp/out ./


RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y curl unzip procps
#RUN curl -sSL https://aka.ms/getvsdbgsh | /bin/sh   /dev/stdin -v latest -l ~/vsdbg
RUN curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /publish/vsdbg;


ENTRYPOINT ["dotnet", "docker-debugger.dll"]

# FROM build AS publish
# RUN dotnet publish "docker-debugger.csproj" -c Release -o /app/publish

# FROM base AS final
# WORKDIR /app
# COPY --from=publish /app/publish .
# ENTRYPOINT ["dotnet", "docker-debugger.dll"]
