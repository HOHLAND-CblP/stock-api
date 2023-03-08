FROM mcr.microsoft.com/dotnet/sdk:5.0 as build

WORKDIR /src
COPY ["src/OzonEdu.StockApi/OzonEdu.StockApi.csproj", "src/OzonEdu.StockApi/"]
RUN dotnet restore "src/OzonEdu.StockApi/OzonEdu.StockApi.csproj"

COPY . .

WORKDIR "/src/src/OzonEdu.StockApi/"

RUN dotnet build "OzonEdu.StockApi.csproj" -c Release -o /app/build

FROM build as publish
RUN dotnet publish "OzonEdu.StockApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:5.0 as runtime

WORKDIR /app

EXPOSE 80

FROM runtime as final
WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "OzonEdu.StockApi.dll"]