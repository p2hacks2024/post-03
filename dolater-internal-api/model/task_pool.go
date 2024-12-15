package model

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type TaskPool struct {
	Id      uuid.UUID
	OwnerId string
	Owner   User
	Type    string // active, archived, pending, bin

	CreatedAt time.Time
	UpdatedAt time.Time
	Deleted   gorm.DeletedAt
}
