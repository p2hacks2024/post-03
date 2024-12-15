package model

import (
	"time"

	"gorm.io/gorm"
)

type User struct {
	Id          string
	DisplayName *string
	PhotoURL    *string

	CreatedAt time.Time
	UpdatedAt time.Time
	Deleted   gorm.DeletedAt
}
