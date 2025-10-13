docker build -f DAK.Dockerfile -t yukikurosawadev/debian_archive_kit:test-build .
docker run -it --rm --privileged yukikurosawadev/debian_archive_kit:test-build
docker rmi yukikurosawadev/debian_archive_kit:test-build