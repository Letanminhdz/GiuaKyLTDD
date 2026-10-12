FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src
COPY ["src/GiuaKi.Web.Host/GiuaKi.Web.Host.csproj", "src/GiuaKi.Web.Host/"]
COPY ["src/GiuaKi.Web.Core/GiuaKi.Web.Core.csproj", "src/GiuaKi.Web.Core/"]
COPY ["src/GiuaKi.Application/GiuaKi.Application.csproj", "src/GiuaKi.Application/"]
COPY ["src/GiuaKi.Core/GiuaKi.Core.csproj", "src/GiuaKi.Core/"]
COPY ["src/GiuaKi.EntityFrameworkCore/GiuaKi.EntityFrameworkCore.csproj", "src/GiuaKi.EntityFrameworkCore/"]
WORKDIR "/src/src/GiuaKi.Web.Host"
RUN dotnet restore 

WORKDIR /src
COPY ["src/GiuaKi.Web.Host", "src/GiuaKi.Web.Host"]
COPY ["src/GiuaKi.Web.Core", "src/GiuaKi.Web.Core"]
COPY ["src/GiuaKi.Application", "src/GiuaKi.Application"]
COPY ["src/GiuaKi.Core", "src/GiuaKi.Core"]
COPY ["src/GiuaKi.EntityFrameworkCore", "src/GiuaKi.EntityFrameworkCore"]
WORKDIR "/src/src/GiuaKi.Web.Host"
RUN dotnet publish -c Release -o /publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
EXPOSE 80
WORKDIR /app
COPY --from=build /publish .
ENTRYPOINT ["dotnet", "GiuaKi.Web.Host.dll"]
