# Use the .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0@sha256:35792ea4ad1db051981f62b313f1be3b46b1f45cadbaa3c288cd0d3056eefb83 AS build-env
WORKDIR /App

# Copy everything to the container
COPY . ./
# Restore as distinct layers
RUN dotnet restore

# Build and publish the application
RUN dotnet publish -c Release -o /App/out

# Use the ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0@sha256:6c4df091e4e531bb93bdbfe7e7f0998e7ced344f54426b7e874116a3dc3233ff
WORKDIR /App

# Expose port 5192
EXPOSE 5192

# Copy the build output to the runtime image
COPY --from=build-env /App/out .

# Verify the DLL file name and set the entry point
ENTRYPOINT ["dotnet", "WebApi.dll"]
