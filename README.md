# SIMPLE LOGIN

This is a simple way to login without using any libraries/gems (e.g. devise, bcrypt, etc.)
* When login reaches 3 consecutive failed attempts, it won't allow anymore future logins.
* The only way to unlock is via rails console or via database.
* Encryption uses SHA256 hash salt.

**NOTES:**
* In case you want to run this locally or deploy this somewhere, it needs `.env` which should contain `CIPHER_SALT` variable (just generate your own salt)
* You also need to have secret key base and/or master key
* You may check the specs/tests to know how it works

Let me know if you have any clarifications. Thanks!

Happy coding! :smile: 
