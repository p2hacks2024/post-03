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
	"gorm.io/gorm/clause"
)

func (s *Server) UpdateUser(c *gin.Context, uid string) {
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

	var requestBody api.UpdateUserInput
	if err := c.BindJSON(&requestBody); err != nil {
		message := err.Error()
		c.AbortWithStatusJSON(http.StatusBadRequest, api.Error{
			Message: &message,
		})
		return
	}

	user := model.User{
		Id:          uid,
		DisplayName: requestBody.DisplayName,
		PhotoURL:    requestBody.PhotoURL,
	}

	if err := db.
		Clauses(clause.Returning{}).
		Updates(&user).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
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

	c.JSON(http.StatusOK, response)
}
