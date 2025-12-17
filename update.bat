docker build -f DAK.Dockerfile -t yukikurosawadev/debian_archive_kit:test-build .
docker run -it --rm --privileged -p 5432:5432 -p 80:80 yukikurosawadev/debian_archive_kit:test-build
docker rmi yukikurosawadev/debian_archive_kit:test-build