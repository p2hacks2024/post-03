package model

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Notification struct {
	Id     uuid.UUID
	UserId string
	User   User
	Title  string
	Body   string
	URL    string

	CreatedAt time.Time
	UpdatedAt time.Time
	Deleted   gorm.DeletedAt
}
