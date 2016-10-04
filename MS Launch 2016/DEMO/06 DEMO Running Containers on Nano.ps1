Break
#
#    06 DEMO Running ITSM Containers on Nano
#
#    Build by: Richard Ulfvin
#    Run on W16-NA1
#

# Build:
docker build -t ulfvins/itsmportal:latest c:\ContainerBuilds\ITSM\

# Run remote
docker -H 192.168.1.101 images

# Start remote
docker run ulfvins/itsmportal -d -p 80:80

# list remote
docker -H 192.168.1.101 ps