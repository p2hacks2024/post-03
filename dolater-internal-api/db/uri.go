package db

import (
	"fmt"
)

func uri(schemaName string) string {
	host, port, dbname, user, password, sslmode, sslrootcert, sslcert, sslkey, timezone := env()

	uri := fmt.Sprintf("host=%s", host)
	uri += fmt.Sprintf(" port=%s", port)
	uri += fmt.Sprintf(" dbname=%s", dbname)
	uri += fmt.Sprintf(" user=%s", user)
	uri += fmt.Sprintf(" password=%s", password)

	if schemaName != "" {
		uri += fmt.Sprintf(" search_path=%s", schemaName)
	}

	if sslmode != "" {
		uri += fmt.Sprintf(" sslmode=%s", sslmode)
	}

	if sslrootcert != "" {
		uri += fmt.Sprintf(" sslrootcert=%s", sslrootcert)

		if sslcert != "" && sslkey != "" {
			uri += fmt.Sprintf(" sslcert=%s sslkey=%s", sslcert, sslkey)
		}
	}

	uri += fmt.Sprintf(" TimeZone=%s", timezone)

	return uri
}
