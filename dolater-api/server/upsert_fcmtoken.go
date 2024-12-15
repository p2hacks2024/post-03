package server

import (
	"log"
	"net/http"

	"github.com/dolater/dolater-api/db"
	api "github.com/dolater/dolater-api/generated"
	"github.com/dolater/dolater-api/model"
	"github.com/dolater/dolater-api/server/utility"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm/clause"
)

func (s *Server) UpsertFCMToken(c *gin.Context) {
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

	var requestBody api.UpsertFCMTokenJSONRequestBody
	if err := c.BindJSON(&requestBody); err != nil {
		message := err.Error()
		c.AbortWithStatusJSON(http.StatusBadRequest, api.Error{
			Message: &message,
		})
		return
	}

	fcmToken := model.FCMToken{
		RegistrationToken: requestBody.Token,
		UserId:            token.UID,
	}

	if err := db.
		Clauses(clause.OnConflict{
			Columns:   []clause.Column{{Name: "registration_token"}},
			DoUpdates: clause.AssignmentColumns([]string{"updated_at"}),
		}).
		Create(&fcmToken).
		Error; err != nil {
		message := err.Error()
		c.JSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
		return
	}

	c.Status(http.StatusNoContent)
}
