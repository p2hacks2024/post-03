package main

import (
	"context"
	"log"
	"os"

	firebaseAdmin "firebase.google.com/go/v4"
	api "github.com/dolater/dolater-internal-api/generated"
	"github.com/dolater/dolater-internal-api/server"
	"github.com/joho/godotenv"
	"google.golang.org/api/firebaseremoteconfig/v1"

	"github.com/gin-gonic/gin"
)

const projectId = "projects/dolater-app"

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Println("Error loading .env file")
	}

	if os.Getenv("MODE") != "DEBUG" {
		os.Setenv("GIN_MODE", "release")
	}

	ctx := context.Background()

	// Firebase
	app, err := firebaseAdmin.NewApp(ctx, nil)
	if err != nil {
		log.Printf("Error initializing app: %v\n", err)
	}

	// RemoteConfig
	frcService, err := firebaseremoteconfig.NewService(ctx)
	if err != nil {
		log.Printf("Error initializing app: %v\n", err)
	}
	remoteConfig, err := frcService.Projects.GetRemoteConfig(projectId).Do()
	if err != nil {
		log.Printf("Error initializing app: %v\n", err)
	}

	r := gin.Default()

	// Server
	s := server.New(app, remoteConfig)
	api.RegisterHandlers(r, s)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	r.Run(":" + port)
}
