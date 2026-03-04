package main

import "os"

var api_key string

func init() {
	if api_key = os.Getenv("API_KEY"); api_key == "" {
		panic("переменная API_KEY не установлена")
	}
}

func GenerateApiKey() string {
	return api_key
}
