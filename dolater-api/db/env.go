package db

import (
	"os"
)

const (
	defaultHost = "127.0.0.1"
	defaultPort = "5432"
	defaultName = "postgres"
	defaultUser = "postgres"
	defaultPass = "postgres"
	defaultTZ   = "UTC"
)

func env() (
	string, // host
	string, // port
	string, // dbname
	string, // user
	string, // password
	string, // sslmode
	string, // sslrootcert
	string, // sslcert
	string, // sslkey
	string, // timezone
) {
	host := os.Getenv("POSTGRES_HOST")
	port := os.Getenv("POSTGRES_PORT")
	dbname := os.Getenv("POSTGRES_NAME")
	user := os.Getenv("POSTGRES_USER")
	password := os.Getenv("POSTGRES_PASS")
	sslmode := os.Getenv("POSTGRES_SSL_MODE")
	sslrootcert := os.Getenv("POSTGRES_ROOT_CERT_PATH")
	sslcert := os.Getenv("POSTGRES_CLIENT_CERT_PATH")
	sslkey := os.Getenv("POSTGRES_CLIENT_KEY_PATH")
	timezone := os.Getenv("TZ")

	if host == "" {
		host = defaultHost
	}
	if port == "" {
		port = defaultPort
	}
	if dbname == "" {
		dbname = defaultName
	}
	if user == "" {
		user = defaultUser
	}
	if password == "" {
		password = defaultPass
	}
	if timezone == "" {
		timezone = defaultTZ
	}

	return host, port, dbname, user, password, sslmode, sslrootcert, sslcert, sslkey, timezone
}
