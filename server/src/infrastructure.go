package main

import "sync"

type UserRepository struct {
	users map[string]string
	mu    *sync.RWMutex
}

func NewUserRepository() UserRepository {
	return UserRepository{
		users: make(map[string]string, 16),
		mu:    &sync.RWMutex{},
	}
}

func (r *UserRepository) signUp(email, password string) error {
	r.mu.Lock()
	defer r.mu.Unlock()

	if _, exists := r.users[email]; exists {
		return ErrUserAlreadyExists
	}

	r.users[email] = password
	return nil
}

func (r *UserRepository) signIn(email, password string) error {
	r.mu.RLock()
	defer r.mu.RUnlock()

	pwd, exists := r.users[email]
	if !exists {
		return ErrUserNotFound
	}

	if pwd != password {
		return ErrInvalidCredentials
	}

	return nil
}
