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

	mapset "github.com/deckarep/golang-set/v2"
)

func (s *Server) GetFriends(c *gin.Context, uid string) {
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

	var followingStatus []model.FollowStatus
	var followedStatus []model.FollowStatus
	if err := db.
		Where(&model.FollowStatus{
			FromId: uid,
		}).
		Find(&followingStatus).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}
	if err := db.
		Where(&model.FollowStatus{
			ToId: uid,
		}).
		Find(&followedStatus).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	followingUids := mapset.NewSet[string]()
	followedUids := mapset.NewSet[string]()
	for _, fs := range followingStatus {
		followingUids.Add(fs.ToId)
	}
	for _, fs := range followedStatus {
		followedUids.Add(fs.FromId)
	}

	friendUids := followingUids.Intersect(followedUids).ToSlice()

	var users []model.User
	if err := db.
		Where("id IN ?", friendUids).
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
