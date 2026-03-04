package main

import "errors"

type SignUpRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type SignInRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type AuthResponse struct {
	APIKey string `json:"api_key"`
}

type ErrorResponse struct {
	Error string `json:"error"`
}

type AnalyticsEvent struct {
	Event string         `json:"event" binding:"required"`
	Data  map[string]any `json:"data" binding:"required"`
}

var (
	ErrUserAlreadyExists  = errors.New("user already exists")
	ErrUserNotFound       = errors.New("user not found")
	ErrInvalidCredentials = errors.New("invalid credentials")
)

const TimeLayout = "2006-01-02 15:04:05"
