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
	"gorm.io/gorm"
)

func (s *Server) GetPools(c *gin.Context) {
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

	pools := []model.TaskPool{}

	if err := db.
		Where(&model.TaskPool{
			OwnerId: token.UID,
		}).
		Find(&pools).
		Error; err != nil {
		message := err.Error()
		c.JSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
		return
	}

	response := []api.TaskPool{}

	for _, pool := range pools {

		owner := model.User{
			Id: pool.OwnerId,
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

		response = append(response, api.TaskPool{
			Id: pool.Id,
			Owner: &api.User{
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
			Type: api.TaskPoolType(pool.Type),
		})
	}

	c.JSON(http.StatusOK, response)
}
