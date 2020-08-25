# For no-cache compilation use --no-cache
docker build --target baseOS \
  -t qmost/l1:v02.1 \
  --build-arg USER_ID="$(id -u)" \
  --build-arg BUILD_DATE="$(date)" . \
  -f qmostdr_l1.Dockerfile
