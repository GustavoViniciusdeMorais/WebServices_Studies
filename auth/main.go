package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()

	// Middleware to check for a custom token
	e.Use(middleware.KeyAuth(func(key string, c echo.Context) (bool, error) {
		return key == "simple_token", nil
	}))

	// Route to validate the token
	e.GET("/validate", func(c echo.Context) error {
		return c.String(http.StatusOK, "Token valid")
	})

	e.Start(":9090")
}
