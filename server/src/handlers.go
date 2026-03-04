package main

import (
	"errors"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	engine     *gin.Engine
	repository *UserRepository
}

func NewHandler(r *gin.Engine, repository *UserRepository) Handler {
	h := Handler{
		engine:     r,
		repository: repository,
	}

	api := r.Group("/api")
	{
		api.POST("/sign-up", h.signUp)
		api.POST("/sign-in", h.signIn)
		api.POST("/analytics", h.analytics)
	}

	return h
}

// POST /api/sign-up
func (h Handler) signUp(c *gin.Context) {
	var req SignUpRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{
			Error: "Неверный формат запроса: " + err.Error(),
		})
		return
	}

	if err := h.repository.signUp(req.Email, req.Password); err != nil {
		if errors.Is(err, ErrUserAlreadyExists) {
			c.JSON(http.StatusBadRequest, ErrorResponse{
				Error: "email уже зарегистрирован",
			})
		} else {
			c.JSON(http.StatusInternalServerError, ErrorResponse{
				Error: "Ошибка сервера",
			})
		}
		return
	}

	c.JSON(http.StatusOK, AuthResponse{
		APIKey: GenerateApiKey(),
	})
}

// POST /api/sign-in
func (h Handler) signIn(c *gin.Context) {
	var req SignInRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{
			Error: "Неверный формат запроса: " + err.Error(),
		})
		return
	}

	if err := h.repository.signIn(req.Email, req.Password); err != nil {
		if errors.Is(err, ErrUserNotFound) {
			c.JSON(http.StatusUnauthorized, ErrorResponse{
				Error: "Пользователь не зарегистрирован",
			})
		} else if errors.Is(err, ErrInvalidCredentials) {
			c.JSON(http.StatusUnauthorized, ErrorResponse{
				Error: "Неверный пароль",
			})
		} else {
			c.JSON(http.StatusInternalServerError, ErrorResponse{
				Error: "Ошибка сервера",
			})
		}
		return
	}

	c.JSON(http.StatusOK, AuthResponse{
		APIKey: GenerateApiKey(),
	})
}

// POST /api/analytics
func (h Handler) analytics(c *gin.Context) {
	var req AnalyticsEvent

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, ErrorResponse{
			Error: "Неверный формат запроса: " + err.Error(),
		})
		return
	}

	fmt.Printf(
		"[%s] [%s] %v\n",
		time.Now().Format(TimeLayout),
		req.Event,
		req.Data,
	)

	c.Status(http.StatusOK)
}
