package handlers

import (
	"context"
	"crypto/sha256"
	"fmt"
	"github.com/razshare/frizzante/frz"
	"main/lib/database"
	"main/lib/generated"
)

func GetRegister(c *frz.Connection) {
	c.SendView(frz.View{Name: "Register"})
}

func PostRegister(c *frz.Connection) {
	form := c.ReceiveForm()
	id := form.Get("id")

	displayName := form.Get("displayName")
	rawPassword := form.Get("password")

	if "" == id || "" == displayName || "" == rawPassword {
		c.SendView(frz.View{Name: "Register", Error: "please fill all fields"})
		return
	}

	password := fmt.Sprintf("%x", sha256.Sum256([]byte(rawPassword)))

	_, accountError := database.Queries.SqlFindAccountById(context.Background(), id)
	if nil == accountError {
		c.SendView(frz.View{Name: "Register", Error: fmt.Sprintf("account `%s` already exists", id)})
		return
	}

	addError := database.Queries.SqlAddAccount(context.Background(), generated.SqlAddAccountParams{
		ID:          id,
		DisplayName: displayName,
		Password:    password,
	})

	if nil != addError {
		c.SendView(frz.View{Name: "Register", Error: addError.Error()})
		return
	}

	c.SendNavigate("/login")
}
