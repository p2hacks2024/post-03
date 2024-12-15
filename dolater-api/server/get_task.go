package server

import (
	"errors"
	"log"
	"net/http"

	"github.com/dolater/dolater-api/db"
	api "github.com/dolater/dolater-api/generated"
	"github.com/dolater/dolater-api/model"
	"github.com/dolater/dolater-api/server/utility"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func (s *Server) GetTask(c *gin.Context, id uuid.UUID) {
	token := utility.GetToken(c)
	if token == nil {
		message := "Unauthorized"
		c.AbortWithStatusJSON(http.StatusUnauthorized, api.Error{
			Message: &message,
		})
		return
	}

	db, err := db.GormDB("public")
	if err != nil {
		message := err.Error()
		c.JSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
		return
	}
	defer func() {
		sqldb, err := db.DB()
		if err != nil {
			log.Println("Failed to close database connection")
		}
		sqldb.Close()
	}()

	task := model.Task{
		Id: id,
	}

	if err := db.
		First(&task).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusNotFound, api.Error{
				Message: &message,
			})
			return
		}
	}

	owner := model.User{
		Id: func() string {
			if task.OwnerId == nil {
				return ""
			}
			return *task.OwnerId
		}(),
	}

	if err := db.
		First(&owner).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	pool := model.TaskPool{
		Id: func() uuid.UUID {
			if task.PoolId == nil {
				return uuid.UUID{}
			}
			return *task.PoolId
		}(),
	}

	if err := db.
		First(&pool).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	poolOwner := model.User{
		Id: pool.OwnerId,
	}

	if err := db.
		First(&poolOwner).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	response := api.Task{
		Id: task.Id,
		Url: func() string {
			if task.URL == nil {
				return ""
			}
			return *task.URL
		}(),
		CreatedAt:   task.CreatedAt,
		ArchivedAt:  task.ArchivedAt,
		CompletedAt: task.CompletedAt,
		Owner: api.User{
			Id: owner.Id,
			DisplayName: func() string {
				if owner.DisplayName == nil {
					return ""
				}
				return *owner.DisplayName
			}(),
			PhotoURL: func() string {
				if owner.PhotoURL == nil {
					return ""
				}
				return *owner.PhotoURL
			}(),
		},
		Pool: api.TaskPool{
			Id: pool.Id,
			Owner: &api.User{
				Id: poolOwner.Id,
				DisplayName: func() string {
					if poolOwner.DisplayName == nil {
						return ""
					}
					return *poolOwner.DisplayName
				}(),
				PhotoURL: func() string {
					if poolOwner.PhotoURL == nil {
						return ""
					}
					return *poolOwner.PhotoURL
				}(),
			},
			Type: api.TaskPoolType(pool.Type),
		},
	}

	c.JSON(http.StatusOK, response)
}
