#!/bin/sh

set -e

DOCKER_BAKE_FILE=${1:-"docker-bake.hcl"}
TAGS=${TAGS:-"12 11 10 9.6 9.5 9.4"}
GOCRONVER=${GOCRONVER:-"v0.0.9"}
PLATFORMS=${PLATFORMS:-"linux/amd64 linux/arm64"}
IMAGE_NAME=${IMAGE_NAME:-"vdo1138/postgres-backup-age"}

cd "$(dirname "$0")"

MAIN_TAG=${TAGS%%" "*}  # First tag
TAGS_EXTRA=${TAGS#*" "} # Rest of tags
P="\"$(echo $PLATFORMS | sed 's/ /", "/g')\""

T="\"debian-latest\", \"$(echo debian-$TAGS_EXTRA | sed 's/ /", "debian-/g')\""

cat >"$DOCKER_BAKE_FILE" <<EOF
group "default" {
	targets = [$T]
}

target "common" {
	platforms = [$P]
	args = {"GOCRONVER" = "$GOCRONVER"}
}

target "debian" {
	inherits = ["common"]
	dockerfile = "Dockerfile-debian"
}

target "debian-latest" {
	inherits = ["debian"]
	args = {"BASETAG" = "$MAIN_TAG"}
	tags = ["$IMAGE_NAME:latest", "$IMAGE_NAME:$MAIN_TAG"]
}
EOF

for TAG in $TAGS_EXTRA; do
	cat >>"$DOCKER_BAKE_FILE" <<EOF

target "debian-$TAG" {
  inherits = ["debian"]
	args = {"BASETAG" = "$TAG"}
  tags = ["$IMAGE_NAME:$TAG"]
}
EOF
done
