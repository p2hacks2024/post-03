package server

import (
	firebaseAdmin "firebase.google.com/go/v4"
	"google.golang.org/api/firebaseremoteconfig/v1"
)

type Server struct {
	FirebaseApp  *firebaseAdmin.App
	RemoteConfig *firebaseremoteconfig.RemoteConfig
}

func New(firebaseApp *firebaseAdmin.App, remoteConfig *firebaseremoteconfig.RemoteConfig) *Server {
	return &Server{
		FirebaseApp:  firebaseApp,
		RemoteConfig: remoteConfig,
	}
}
