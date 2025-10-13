docker build -f dak.Dockerfile -t yukikurosawadev/debian_archive_kit:latest .
docker run -it --rm yukikurosawadev/debian_archive_kit:latest
docker rmi yukikurosawadev/debian_archive_kit:latest