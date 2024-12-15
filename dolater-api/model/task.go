package model

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Task struct {
	Id          uuid.UUID
	URL         *string
	CompletedAt *time.Time
	RemovedAt   *time.Time
	ArchivedAt  *time.Time
	OwnerId     *string
	Owner       *User
	PoolId      *uuid.UUID
	Pool        *TaskPool

	CreatedAt time.Time
	UpdatedAt time.Time
	Deleted   gorm.DeletedAt
}
