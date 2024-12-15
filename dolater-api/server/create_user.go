package server

import (
	"errors"
	"log"
	"net/http"
	"slices"

	"github.com/dolater/dolater-api/db"
	api "github.com/dolater/dolater-api/generated"
	"github.com/dolater/dolater-api/model"
	"github.com/dolater/dolater-api/server/utility"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

func (s *Server) CreateUser(c *gin.Context) {
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

	var displayName string
	var photoURL string
	var ok bool

	displayName, ok = token.Claims["name"].(string)
	if !ok {
		displayName = ""
	}
	photoURL, ok = token.Claims["picture"].(string)
	if !ok {
		photoURL = ""
	}

	user := model.User{
		Id:          token.UID,
		DisplayName: &displayName,
		PhotoURL:    &photoURL,
	}

	response := api.User{
		Id: user.Id,
		DisplayName: func() string {
			if user.DisplayName == nil {
				return ""
			}
			return *user.DisplayName
		}(),
		PhotoURL: func() string {
			if user.PhotoURL == nil {
				return ""
			}
			return *user.PhotoURL
		}(),
	}

	if err := db.
		Clauses(clause.OnConflict{
			Columns:   []clause.Column{{Name: "id"}},
			DoUpdates: clause.AssignmentColumns([]string{"display_name", "photo_url"}),
		}).
		Create(&user).Error; err != nil {
		message := err.Error()
		c.AbortWithStatusJSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
		return
	}

	var taskPools []model.TaskPool

	if err := db.
		Where(&model.TaskPool{
			OwnerId: token.UID,
		}).
		Find(&taskPools).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	taskPoolTypes := []api.TaskPoolType{
		api.TaskPoolTypeActive,
		api.TaskPoolTypeArchived,
		api.TaskPoolTypeBin,
		api.TaskPoolTypePending,
	}
	existingTaskPoolTypes := []api.TaskPoolType{}

	for _, pool := range taskPools {
		if slices.Contains(taskPoolTypes, api.TaskPoolType(pool.Type)) && !slices.Contains(existingTaskPoolTypes, api.TaskPoolType(pool.Type)) {
			existingTaskPoolTypes = append(existingTaskPoolTypes, api.TaskPoolType(pool.Type))
		}
	}

	for _, poolType := range taskPoolTypes {
		if !slices.Contains(existingTaskPoolTypes, poolType) {
			taskPools = append(taskPools, model.TaskPool{
				Id:      uuid.New(),
				OwnerId: user.Id,
				Type:    string(poolType),
			})
		}
	}

	if err := db.
		Clauses(clause.OnConflict{
			DoNothing: true,
		}).
		Create(&taskPools).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	c.JSON(http.StatusCreated, response)
}
