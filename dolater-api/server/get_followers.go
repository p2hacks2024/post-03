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
	"gorm.io/gorm"
)

func (s *Server) GetFollowers(c *gin.Context, uid string) {
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

	var followStatus []model.FollowStatus
	if err := db.
		Where(&model.FollowStatus{
			ToId: uid,
		}).
		Find(&followStatus).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	uids := []string{}
	for _, fs := range followStatus {
		if fs.FromId != token.UID && !slices.Contains(uids, fs.FromId) {
			uids = append(uids, fs.FromId)
			continue
		}
		if fs.ToId != token.UID && !slices.Contains(uids, fs.ToId) {
			uids = append(uids, fs.ToId)
			continue
		}
	}

	var users []model.User
	if err := db.
		Where("id IN ?", uids).
		Find(&users).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	response := []api.User{}
	for _, user := range users {
		response = append(response, api.User{
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
		})
	}

	c.JSON(http.StatusOK, response)
}
