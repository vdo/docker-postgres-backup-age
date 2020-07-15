group "default" {
	targets = ["debian-latest", "debian-11", "debian-10", "debian-9.6", "debian-9.5", "debian-9.4"]
}

target "common" {
	platforms = ["linux/amd64", "linux/arm64"]
	args = {"GOCRONVER" = "v0.0.9"}
}

target "debian" {
	inherits = ["common"]
	dockerfile = "Dockerfile-debian"
}

target "debian-latest" {
	inherits = ["debian"]
	args = {"BASETAG" = "12"}
	tags = ["vdo1138/postgres-backup-age:latest", "vdo1138/postgres-backup-age:12"]
}

target "debian-11" {
  inherits = ["debian"]
	args = {"BASETAG" = "11"}
  tags = ["vdo1138/postgres-backup-age:11"]
}

target "debian-10" {
  inherits = ["debian"]
	args = {"BASETAG" = "10"}
  tags = ["vdo1138/postgres-backup-age:10"]
}

target "debian-9.6" {
  inherits = ["debian"]
	args = {"BASETAG" = "9.6"}
  tags = ["vdo1138/postgres-backup-age:9.6"]
}

target "debian-9.5" {
  inherits = ["debian"]
	args = {"BASETAG" = "9.5"}
  tags = ["vdo1138/postgres-backup-age:9.5"]
}

target "debian-9.4" {
  inherits = ["debian"]
	args = {"BASETAG" = "9.4"}
  tags = ["vdo1138/postgres-backup-age:9.4"]
}
