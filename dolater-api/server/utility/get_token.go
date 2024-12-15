package utility

import (
	"firebase.google.com/go/v4/auth"
	"github.com/gin-gonic/gin"
)

func GetToken(c *gin.Context) *auth.Token {
	token, ok := c.Get("X-Firebase-Authentication-ID-Token")
	if !ok {
		return nil
	}
	return token.(*auth.Token)
}
