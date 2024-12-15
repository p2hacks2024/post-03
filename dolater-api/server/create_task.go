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
	"gorm.io/gorm/clause"
)

func (s *Server) CreateTask(c *gin.Context) {
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

	var requestBody api.CreateTaskInput
	if err := c.BindJSON(&requestBody); err != nil {
		message := err.Error()
		c.AbortWithStatusJSON(http.StatusBadRequest, api.Error{
			Message: &message,
		})
		return
	}

	var activePool model.TaskPool
	if err := db.
		Where(&model.TaskPool{
			OwnerId: token.UID,
			Type:    string(api.TaskPoolTypeActive),
		}).
		First(&activePool).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	task := model.Task{
		Id:      uuid.New(),
		OwnerId: &token.UID,
		URL:     &requestBody.Url,
		PoolId:  &activePool.Id,
	}

	if err := db.
		Clauses(clause.OnConflict{
			DoNothing: true,
		}).
		Create(&task).
		Error; err != nil {
		message := err.Error()
		c.JSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
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

	response := api.Task{
		Id: task.Id,
		Url: func() string {
			if task.URL == nil {
				return ""
			}
			return *task.URL
		}(),
		CreatedAt:   task.CreatedAt,
		CompletedAt: task.CompletedAt,
		ArchivedAt:  task.ArchivedAt,
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
			Id:   activePool.Id,
			Type: api.TaskPoolType(activePool.Type),
		},
	}

	c.JSON(http.StatusCreated, response)
}
