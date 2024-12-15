package model

import (
	"time"

	"gorm.io/gorm"
)

type FollowStatus struct {
	FromId string `gorm:"primaryKey"`
	From   User
	ToId   string `gorm:"primaryKey"`
	To     User

	CreatedAt time.Time
	UpdatedAt time.Time
	Deleted   gorm.DeletedAt
}
