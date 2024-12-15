package db

import (
	"log"

	"github.com/dolater/dolater-api/model"
)

func Migrate() {
	db, err := GormDB("public")
	if err != nil {
		log.Println("Failed to connect database")
	}
	defer func() {
		sqldb, err := db.DB()
		if err != nil {
			log.Println("Failed to close database connection")
		}
		sqldb.Close()
	}()

	err = db.AutoMigrate(&model.FCMToken{})
	if err != nil {
		log.Println("Failed to migrate database")
	}

	err = db.AutoMigrate(&model.User{})
	if err != nil {
		log.Println("Failed to migrate database")
	}

	err = db.AutoMigrate(&model.TaskPool{})
	if err != nil {
		log.Println("Failed to migrate database")
	}

	err = db.AutoMigrate(&model.Task{})
	if err != nil {
		log.Println("Failed to migrate database")
	}

	err = db.AutoMigrate(&model.FollowStatus{})
	if err != nil {
		log.Println("Failed to migrate database")
	}

	err = db.AutoMigrate(&model.Notification{})
	if err != nil {
		log.Println("Failed to migrate database")
	}
}
