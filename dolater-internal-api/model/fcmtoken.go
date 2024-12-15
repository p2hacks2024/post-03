package model

import (
	"time"

	"gorm.io/gorm"
)

type FCMToken struct {
	RegistrationToken string `gorm:"primaryKey"`
	UserId            string

	CreatedAt time.Time
	UpdatedAt time.Time
	Deleted   gorm.DeletedAt
}
