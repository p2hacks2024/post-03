package db

import (
	"database/sql"
	"fmt"
)

func sqlDB(schemaName string) (*sql.DB, error) {
	db, err := sql.Open("pgx", uri(schemaName))
	if err != nil {
		return nil, fmt.Errorf("sql.Open error: %s", err)
	}

	return db, err
}
