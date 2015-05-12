== README

You'll need to create a `.env` or a `.env.development` file that looks something like this...

```
HEROKU_AUTH_TOKEN=super-secret-auth-token-from-heroku
DEVISE_SECRET_KEY=generate-by-running-rake-secret

G5_AUTH_CLIENT_ID=gigitygigitygigitygigity
G5_AUTH_CLIENT_SECRET=blahblahblahblahblahblahblah
G5_AUTH_REDIRECT_URI=http://localhost:3000/g5_auth/users/auth/g5/callback 
G5_AUTH_ENDPOINT=https://dev-auth.g5search.com
```
