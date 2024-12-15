package server

import (
	"errors"
	"log"
	"net/http"
	"net/url"

	"firebase.google.com/go/v4/messaging"
	"github.com/dolater/dolater-api/db"
	api "github.com/dolater/dolater-api/generated"
	"github.com/dolater/dolater-api/model"
	"github.com/dolater/dolater-api/server/utility"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func (s *Server) NotifyTask(c *gin.Context, id uuid.UUID) {
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

	var requestBody api.NotifyTaskInput
	if err := c.BindJSON(&requestBody); err != nil {
		message := err.Error()
		c.AbortWithStatusJSON(http.StatusBadRequest, api.Error{
			Message: &message,
		})
		return
	}

	task := model.Task{
		Id: id,
	}

	if err := db.First(&task).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			message := "Task not found"
			c.JSON(http.StatusNotFound, api.Error{
				Message: &message,
			})
			return
		}
	}

	taskOwner := model.User{
		Id: func() string {
			if task.OwnerId == nil {
				return ""
			}
			return *task.OwnerId
		}(),
	}

	if taskOwner.Id == token.UID {
		message := "You cannot notify yourself"
		c.JSON(http.StatusBadRequest, api.Error{
			Message: &message,
		})
		return
	}

	displayName := func() string {
		if taskOwner.DisplayName == nil {
			return ""
		}
		return *taskOwner.DisplayName
	}()

	notification := model.Notification{
		Id:     uuid.New(),
		UserId: taskOwner.Id,
		Title:  "あーあ...急いで!!",
		Body: func() string {
			if displayName == "" {
				return requestBody.Emoji + "誰かに催促されています"
			}
			return requestBody.Emoji + displayName + " さんに催促されています"
		}(),
		URL: "https://dolater.kantacky.com/tasks/" + task.Id.String() + "?emoji=" + url.QueryEscape(requestBody.Emoji),
	}

	if err := db.Create(&notification).Error; err != nil {
		message := err.Error()
		c.JSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
		return
	}

	var fcmToken model.FCMToken

	if err := db.
		Where(&model.FCMToken{
			UserId: taskOwner.Id,
		}).
		First(&fcmToken).
		Error; err != nil {
		if !errors.Is(err, gorm.ErrRecordNotFound) {
			message := err.Error()
			c.JSON(http.StatusInternalServerError, api.Error{
				Message: &message,
			})
			return
		}
	}

	// 通知メッセージを作成
	messages := []*messaging.Message{}
	messages = append(messages, &messaging.Message{
		Data: map[string]string{
			"url": notification.URL,
		},
		Notification: &messaging.Notification{
			Title: notification.Title,
			Body:  notification.Body,
		},
		APNS: &messaging.APNSConfig{
			Payload: &messaging.APNSPayload{
				Aps: &messaging.Aps{
					Sound: "default",
				},
			},
		},
		Token: fcmToken.RegistrationToken,
	})

	if len(messages) == 0 {
		c.Status(http.StatusNoContent)
		return
	}

	// 通知を送信
	client, err := s.FirebaseApp.Messaging(c)
	if err != nil {
		message := err.Error()
		c.AbortWithStatusJSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
		return
	}

	_, err = client.SendEach(c, messages)
	if err != nil {
		message := err.Error()
		c.AbortWithStatusJSON(http.StatusInternalServerError, api.Error{
			Message: &message,
		})
		return
	}

	c.Status(http.StatusNoContent)
}
