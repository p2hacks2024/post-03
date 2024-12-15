package server

import (
	"log"
	"net/http"

	"github.com/dolater/dolater-internal-api/db"
	api "github.com/dolater/dolater-internal-api/generated"
	"github.com/gin-gonic/gin"
)

const parameterName = "task_pool_capacity"

func (s *Server) CheckCapacity(c *gin.Context) {
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

	log.Println(s.RemoteConfig.Parameters[parameterName].DefaultValue.Value)

	c.Status(http.StatusNoContent)
}
