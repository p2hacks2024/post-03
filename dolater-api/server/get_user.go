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

func (s *Server) GetUser(c *gin.Context, uid string) {
	token := utility.GetToken(c)
	if token == nil {
		message := "Unauthorized"
		c.AbortWithStatusJSON(http.StatusUnauthorized, api.Error{
			Message: &message,
		})
		return
	}

	// if token.UID != uid {
	// 	message := "Unauthorized"
	// 	c.AbortWithStatusJSON(http.StatusUnauthorized, api.Error{
	// 		Message: &message,
	// 	})
	// 	return
	// }

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

	user := model.User{
		Id: uid,
	}
	if err := db.
		First(&user).
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
