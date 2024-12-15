package middleware

import (
	firebaseAdmin "firebase.google.com/go/v4"
)

type Middleware struct {
	FirebaseApp *firebaseAdmin.App
}

func New(
	firebaseApp *firebaseAdmin.App,
) *Middleware {
	return &Middleware{
		FirebaseApp: firebaseApp,
	}
}
