# Rails Routes & Controllers

## Introduction

### Review of API
- ***application programming interface***

  public interface (set of rules) for how a particular piece of software works
    - i.e. all public methods of an Ruby object is the API for that object
- for Rails
    - API refers to the HTTP routes in today’s learning

### Web Service (API) vs. Website
- server:
  - the local where it resides code that listens for requests and serves up response
- website: 
    - return type: includes assets to be rendered by the browser
- web service:
    - usage: mobile apps; server-to-server communication, client-side rendering of data
    - return type: data only

  | |website|web service|
  |-|-|-|
  |for|a human to interface with|a machine/developer to interface with|
  |return type|content that can be rendered|data that can be used/manipulated|

### HTTP Requests/Responses Cycle
- ***HTTP***: ***hypertext transfer protocal***
- HTTP Request
  - communication from client to server
  - comprised of:
    - ***Request Line***
      - Request ***Methods*** (aka. ***HTTP Verb***)
        - ***CRUD***
          |Method|Behavior|
          |-|-|
          |`POST`|create|
          |`GET`|Read|, 
          |`PATCH`|Update, also `PUT`|
          |`DELETE`|Delete| 
      - Request ***Path***
          - ***`/users`***, …
      - ***Query String***
          - *`?key=val&key1=val1…`*
          - *optional*
    - Request ***Header***
      - metadata about the request
        - i.e. the host
      - `Host: www.xxxx.com`
    - Request ***Body***
      - a form-like piece of additional data
        - `key_name=val`
      - should not have a request body in GET request
      - *optional*
- parsing parts of a url
  |protocol| |comain| |resource path| |
  |-|-|-|-|-|-|
  |`https:`|//|`www.online-stopwatch.com`|/|`dino-race`|/|

- HTTP Response
    - communication from server to client
    - components
      - status
        |level|type|example|
        |-|-|-|
        |1xx|informational response|
        |2xx|success|`200` (OK),|
        |3xx|redirection|
        |4xx|client errors|`403`, `404` (Not Found), `424` (unprocessable entity)|
        |5xx|server errors|
      - Headers
        - i.e. `Content-Type: text/html`
      - Body
        - the main information of the data returned
        - i.e. the actual HTML document
---
## REST
- representational state transfer
- creates predictability of APIs

### Rails' ***RESTful*** architecture
- The Controller methods should follow ***RESTful*** naming convention
  |Model method|Controller method|HTTP verb|path|route type|Description|
  |-|-|-|-|-|-|
  |`#all`|`#index`|`GET`|`/nouns`|collection|render all instances|
  |`#find_by`|`#show`|`GET`|`/nouns/:id`|-|display a specific instance|
  ||`#new`|`GET`|`/nouns/new`|-|receive HTML Form for creating a new instance|
  |`#create`|`#create`|`POST`|`/nouns`|member|upload and create a new instance|
  ||`#edit`|`GET`|`/nouns/:id/edit`|member|receive HTML Form to modify an existing instance|
  |`#update`|`#update`|`PATCH` / `PUT`|`/nouns/:id`|member|update a modified instance|
  |`#destroy`|`#destroy`|`GET`|`/nouns/:id`|member|delete a specific instance|
---
## Rails Routing
### Router
- takes in http requests and decides where to ***send*** them

### Show Routing Status
**`bundle exec rake routes`**
- show what the routes actually are after processing the routes file

### Routes File
- using rail to take an HTTP request and populate an HTTP response
    - ***`./config/routes.rb`***
        1.  http request hits the ***Rails Router***
        2.  Router Checks RouteThe Rails router checks the path and method of the request 
        3.  Router Initializes a Controller
            - Determines which `Controller` class the request should be sent to
            - Creates a new `Controller` instance
        4.  Calls the Right Controller Action


- uses **DSL (Domain Specific Language)** to define routes
  - *`http_method_name 'path_to_be_matched', to: 'ControllerClass#action_name'`
  - code sample
    ```ruby
    get ("table_nouns/:id", { # if "superheroes/:id" is passed
      to: "table_nouns#show"  # then param will include {id: 20}
    })
    ```
      - `:id`: a ***wildcard*** that will show up in `params` as a key value pair
- [shortcut] ***ad hoc routes***
  - `resources :table_nouns`, 
    - automatically generate the following routes for controller class `TableNoun`: 

      `[:index, :show, :create, :update, :destroy]`
    - include/exclude certain actions
    ```ruby
    resources :table_nouns, only: [action_name1, action_name2, ...] #include
    resources :table_nouns, except: [action_name1, action_name2, ...] #exclude
    ```

  - [caveat] the naming of routes and controllers should follow ***REST (representational state transfer)***
  - prefix methods
    - `nouns_url` - `"https://domain_name/nouns"`
    - `noun_url(model_instance)` - `"https://domain_name/nouns/:id"`

- Nested `resources` Block
  - purpose: to acquire some additional information from the outer table
  - ```ruby
    resources :superheroes do 
      resources :abilities, only: [:index]
    end

    #is equivalent to:

    get ‘superheroes/(:id/)ablities’,
      to: "superheroes#index"
    ```
  
  - **[caveat] *member routes* should **NOT** be nested**
      | |***collection routes***|***member routes***|
      |-|-|-|
      |associated with|the entire collection of specified items|a particular item in a collection|
      |nesting|can be nested|not recommended|
  - **[caveat] do NOT nest more than 1 level**

---
## Rails Controller
- take in http requests from router, decides what to do with them and how to respond

### Controller File
- Start Rails Server
  - **`rails s`**
- `./config/appliction_controller.rb`
  - `skip_before_action: verify_authenticity_token`
  - **[caveat] this disables auth. NEVER use this in production!**
- Create a Controller File
  - **`rails g controller nouns`**
  (naming convention: ***nouns_controller.rb`***)
  1. creates a class called `NounsController < ApplicationController`
  2. defines instance methods corresponding to the action names
- Testing
  - test through ***Postman*** (Chrome extension)
- **[caveat] every controller method has to either render or redirect, and can only to either render or redirect once**

- `params`
  - the router receives arguments from the following places and convert them into key-value pairs:
    - the ***wildcards*** in the URL
    - the ***query string*** in the URL
    - the ***request body***
      - **[caveat] should be avoided for `GET` requests**
  - `params` is like a hash

- `render`
  - to present something on the client side
    - render(option_hash)
  - code samples
    ```ruby
    render json: val #, OR:
    render text: val
    render ..., status: 422 # unprocessable entity response
    render show: 'erb_file_name' #default; syntactic sugar below:
    render 'erb_file_name'
    ```
  - **[caveat]: ALWAYS include the status code for a failed situation rendering!!!**
- `redirect_to`
  - creates another request
  - syntax
    - `redirect_to './url_name_defined_in_router'` or `redirect_to prefix_url`
  - [note] the router's prefix_url mthod can be used in the view erb files
  - sends a `302` (redirect) response to the user
  - **[caveat] do not use `render :view_to_be_redirected`**
  - **[caveat] *double render error*: `render` and `redirect_to` cannot co-exist in a method** 
  

- ***Strong Parameters***
  ```ruby
  param
    .require(:noun)
    .permit(:col_key1, :col_key2, ...)
    #filters any nested keys not specified herein
  ```
---
## Model Methods
- destroy
  - [caveat] once an instance is successfully deleted, the associated row will be removed from the database. However, rails will not decrement the id.

