# Stage 1: Build & Publish
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy project file and restore dependencies
COPY ["back-end.csproj", "./"]
RUN dotnet restore "back-end.csproj"

# Copy source code and build release package
COPY . .
RUN dotnet publish "back-end.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080

# Use non-root app user provided by Microsoft .NET container image
USER $APP_UID

COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "back-end.dll"]
