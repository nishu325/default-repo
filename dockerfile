FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["RenderDeploye/RenderDeploye.csproj", "RenderDeploye/"]
RUN dotnet restore "RenderDeploye/RenderDeploye.csproj"

COPY . .
WORKDIR "/src/RenderDeploye"
RUN dotnet publish "RenderDeploye.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# For Render to work with PORT
ENV ASPNETCORE_URLS=http://+:$PORT

ENTRYPOINT ["dotnet", "RenderDeploye.dll"]
