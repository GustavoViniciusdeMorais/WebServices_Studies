package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()

	// Route to handle requests to /service1
	e.GET("/service1/*", func(c echo.Context) error {
		return c.String(http.StatusOK, "Service1 endpoint reached")
	})

	e.Start("0.0.0.0:9091")
}
