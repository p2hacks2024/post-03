package server

import (
	firebaseAdmin "firebase.google.com/go/v4"
)

type Server struct {
	FirebaseApp *firebaseAdmin.App
}

func New(firebaseApp *firebaseAdmin.App) *Server {
	return &Server{FirebaseApp: firebaseApp}
}
