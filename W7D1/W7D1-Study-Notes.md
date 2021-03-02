# Rails Authentication
## Securely Storing Passwords in DB
- Why saving plaintext passwords in the DB is not a good idea?
- Why saving encoded/encrptyed passwords in the DB is not a good idea?
  - ***Encoding*** vs ***Encrypting***
    - ***Encoding***: reorganize information following certain rules
    - ***Encrypting***: encoding information with a specific key that stores the parameters needed for the encoding rules
  -  encrypting is still not safe enough for authentication because it involves using a key to turn plaintext to something else. Since the key has to store somewhere, anything encrpted can be decrypted with the key.
  - encryption is two-way
- What is the good solution?
  - hashing
  - Four key principles of hashing
    - ***one-way*** - an output can be produced with a given input but not vice versa
    - ***deterministic*** - same input leads to the same output every time
    - ***uniform*** - reduces the amount of possible ***hash collisions***
      - the ***pigeon-hole problem***
    - ***sensitive*** - a small change to the input results in an entirely different hash
    Hashing

### Authentication through hashing
- store the the hashed password value (aka. ***password digest***) to the server
- run the hash function to match user input password with the stored ***password digest***
- [caveat] ***hash collision*** chances of hash collision may impair security
- ***cyptographic hashing functions***
  - slow, but extremely low collisions
  - types
    - unsafe: SHA-1, MD5
    - recommended: BCrypt (Blowfish)

## Why authentication?
- prevent people from peeking into other people's privacy
  - i.e. should everyone be allowed to access *`amazon.com/carts/20`*?
  - [caveat] simply encrypting the id number is NOT a good idea, as the url address may be accessed by whoever owns it
---
## Cookies - little pieces of data (4kb) sent from a website to user browser
- HTTP is ***stateless*** on the server and client site
  - each client request is independent from every other
  - the Rails controller dies at the end of every request
- cookies is a giant hashmap storing states
  - ***permanent cookie*** (not truly permanent)
    - a cookie that lives as long as 20 years
  - ***session cookie***
    - a cookie that will be deleted when the browser closes
- user browsers set up rules of cookies
- early solution to authentication
  - **[caveat] still does not solve 100% the authentication problem**
    - whoever has the cookies can access user data
    - everyone can create/change cookies access other users' data by random guesses (esp. if the entropy is low)
- fundamental solution - including ***session token*** in the cookie
  - every time a user logs in (sends username and password to the server), the server returns a cookie with username, password, AND **session token**  
  - the session token will be destroyed if the user logs out
  - [caveat] someone may still obtain user information by SQL injection
---
## ***Salting***
- Weakness of hashing
  - **USERS ARE STUPID**
    - users enter same password for different websites
      - a malicious website could use SQL injection to steal usernames and passwords and try on different websites
    - users don't choose random passwords
      - 90% of the users use the 1000 most common passwords
    - ***Rainbow Table Attack***
      - hackers using frequently-used passwords to match the hashed results
- ***Salting***
  - generate a unique random string (aka. ***salt***)
  - pair the password with the ***salt*** and generate a hash from that to add ***entropy***
  - needs to store the salt along with the hash in the DB
- hashing for multiple times
  - inceases the time of hashing; therefore increase the time and cost for a hacker to crack a password 
---
## Bcrypt
- one-way hasing function
- features
  - incorporates a ***salt*** to prevent hash/rainbow table attacks
  - slower relative to other hasing algorithms (*which is good*)
  - adaptive, scales with computational power, resistant to brute-force
  - verfies if two hashes were created rom the same input without needing to reveal them
- not exclusive to Ruby or Rails
- use
  - `require 'bcrypt'`
  - include `bcrypt` in the **`Gemfile`**
- methods
  - `BCrypt::Password#create('password')`
    - create a BCrypt password
  - `BCrypt::Password#new(bcrypt_pwd_string)`
    - turns a previously generated string back to a `BCrypt::Password` object
  - `bcrypt_pwd_string.is_password?(password)`
    - verifying BCrypt password
    - [caveat] expensive
---
## Rails Session
### ***session***
- a session is:
  - a hash-like object that key-value pairs reside, allowing for a nice interface to manage cookies and allow data to persist across request-reponse cycles
  - sends cookies back down to browser with each response (browsers send them back up with each request)
  - only available in controllers and views
  - an interaction between the client and the server

- Cookies vs. Session
  - ***session*** is a concept; ***cookies*** are the implementation
- different ways to implement a session
  - store data in an HTTP cookie (default)
  - store all session data in the server's DB; only send database id to the client

### Rails `ApplicationController::Base#session` method
- akin to `ApplicationController::param`
- controller method to get a hash-like object that can set state and be retrieved 
  - setting the state
    - `session[:session_token] = val`
  - Rails will save the `session` contents in the cookie when `render` or `redirect` is called 
- remove a session: `session[:session_token] = nil`

### Rails `ApplicationController::Base#Flash` method
- ***Flash*** - A special session that stores data only for the current request and the next request
- `#flash` vs. `#flash.now`
  | |`#flash`|`#flash.now`|
  |-|-|-|
  |lifetime|current & next requests|current request ONLY|
  |used for|`redirect`|`render`|
  |syntax|`flash[:user_error] = "error_message"`|`flash.new[:user_error] = "error_message"`|
- The low-level invocation of `ActionController::Base#cookies` method
  - gets/sets data to an HTTP cookie directly
  - ```ruby
    cookies[:session_token] = {
      value: session_token,
      expires: 20.year.from_now #20 max; defaults to be cleared after browser closes
    }
    # is equivalent to:
    cookies.permanent[session_token] = session_token
    ```
  - **[caveat] always use `session`; avoid using `cookies`**
  - **[caveat] a cookie's value has to be a string. (de-)/serielization will be needed**
---
## Auth Pattern
- **[caveat] NEVER write your own authentication**
- Authentication under the hood
  - User Model
    - `validates :password, length: {minimum: length, allow_nil: true}`
    - overwrite `User#password=(pwd)` method
      self.password_digest = BCrypt::Password.create(...)
    - session token methods
      - `generate_session_token`
      - `ensure_session_token`
      - `reset_session_token`
    - `User#find_by_credentials(username, pwd)`
  - Controllers
    - `UsersController`
      - `#new`
      - `#create`
    - `SessionController`
      - Manage the login session
      - `#new` - log in
      - `#create` - logs the user in
      - `#destroy` - log out
    - `ApplicationController`
      - `#curent_user` - use the session token to identify the user
      - `#login!(user)`
      - `#redirect_unless_logged_in`
---
## CSRF and Forms
- ***CSRF - Cross-site Request Forgery***
  - use a deceptive form to complete certain request methods towards another website
- Prevention
  - Rail by default sets an ***authenticity token*** in the session for each request
  - Rail expects the client to **upload the *authenticity token* in the params** when making any non-GET request
  - the `form_authenticity_token` helper takes the ***authenticity token*** stored in the user session, puts it in the form, and check if the param token equals the session token once the form is submitted
    ```erb
    <form>
      <input  type="hidden"
              name="authenticity_token"
              value="<%= form_authenticity_token %>"
      >
    </form>
    ``` 
- If the param token and the session token do not match
  - By default, Rails will raise `ActionController::InvalidAuthenticityToken` **exception**
  - optionally, this can be changed in **`application_controller.rb`** to set to `:null_session`
    - this way, no error will be raised but Rails will blank out the session and log out the user
---
## User Sign Up, Log In, & Log Out
### schema
|name|type|presence|uniqueness|
|-|-|-|-|
|username|string|true|true|
|password_digest|string|false|-|
|session|string|true|true|

### Relevant Routes
- sign up
  - `get '/users/new', to: 'users#new'`
  - `post '/users', to: 'users#create'`
- log in
  - `get '/session/new', to: 'session#new'`
  - `post '/session', to: 'session#create'`
- log out
  - `delete '/sesson', to: 'session#destroy'`
### generating Auth Routes
- `resources :users, only: [:new, :create]`
- `resource :session, only: [:new, :create, :destroy]`
  - [caveat] `resource` here is singular!
  - _https://stackoverflow.com/questions/11356146/difference-between-resource-and-resources-in-rails-routing_
### Gems
- `better_errors`
  - different and nicer looking error page
  - full stack trace
  - source line in editor
- `binding_of_caller`
  - enables extra features in `better_errors`
  - repl on error page
  - local & instance variable inspection

### implementation
- `#password=`
  - create a `@password` instance variable and generate `password_digest`
  - add validation of @password `validates :password, length: {minimum: 6, allow_nil: true}`
    - [note] `validates` **not only** works for instance variables corresponding to a table column
- `#ensure_session_token`
  - callback method to ensure that a session token exists
    - `after_initialize :ensure_session_token`
  - `self.session_token ||= SecureRandom::urlsafe_base64`

### Determining a user is logged in
- cookies
- a user is logged in if
  user.session_token == session[:session_token]
- router
  - `resource :session, only: [:new, :create, :delete]`
- model
  - `User`
    - `#find_by_credentials(username, pwd)` - find user by usrname and pwd
    - `#is_password?(pwd)` - check if the password from the argument corresponds to the BCrypt in the DB
      - `BCrypt::Password.new(self.password_digest) == pwd`
        - [note] `BCrypt::Password.new` is necessary every time we check a password because **"self.password_digest" returns a string**
    - `#ensure_session_token`
    - `#reset_session_token`
      ```ruby
      self.session_token = SecureRandom::urlsafe_base64
      self.save!
      self.session_token
      ```
- controller
  - `SessionsController`
    - `#new` - sign up
    - `#create`
      - create a new `SessionsController` instance
        - if a user is found, log in user
        - otherwise, go to the sign up page
      - `user = User.find_by_credentials(username, password)`
        - `session[:session_token] = user.session_token if user`
    - `#destroy`
      - log out and redirect to the sign in page
  - `ApplicationController`
    - `before_action: :require_logged_in, only: [:index]`
    - `#login!(user)`
      - `session[:session_token] = user.reset_session_token!`
    - `#current_user`
      - `@current_user ||= User.find_by(session_token: session[:session_token])`
    - `#logged_in?`
      - `!!self.current_user`
    - `#require_logging_in`
      - `redirect_to new_session_url unless logged_in?`
    - `#logout!`
      ```ruby
      self.current_user.reset_session_token! if self.logged_in?
      session[:session_token] = nil
      @current_user = nil
      ```
      - [caveat] always reset `@current_user`'s session token when loggout. **DO NOT set it to nil!** Otherwise, `#current_user` could return any users with a `nil` session token. 