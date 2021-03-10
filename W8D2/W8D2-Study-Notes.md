***server***
- software that processes http requests and responses

***middleware***
- sits between webserver and development server
- coordinates communication in between
- acts as the middle person that takes the requests and responses and format them 

## ***TCP/IP***
- ***IP*** - ***internet protocol***
  - the principal communication protocol responsible for routing data packets from source to destination
  - provides "best-effort delivery"
    - does not guarantee that the data is not corrupted or lost
- ***TCP*** - ***transmission control protocol***
  - higher level protocal running on top of IP that ensures information is reliable
  - establishes connection to a specific port through handshake process
  - ***TCP handshake*** (3 steps)
    - synchronize: computer A sends computer B message
    - synchronize-Acknowledgement - Computer B sends message back to Computer A, acknowledging that it received it
    - Acknowledgement - Computer A send message back to Computer B, acknowledging that it received it
- ***HTTP*** - ***Hypertext Transfer Protocol***
  - Rules for how actual content of request/response should **look**
  - assumes an underlying and reliable transport layer (i.e. TCP/IP)
  - versions
    - HTTP/1.1
      - used to be most common
      - allows for 1 outstanding request
    - HTTP/2 - used by 41.1% of the top 10 million websites
      - currently most common
      - growing rapidly!
      - allows for **multiple** outstanding requests
        - speeds up the connection speed

### HTTP Headers
- set of key-value pairs that specify various properties of the HTTP request/response
- Request
  - only one required header (in HTTP/1.1): `Host`
  - most common ones:
    - `Accept`
    - `Content-Type`
    - `Cookie`
    - `User-Agent`
    - _en.wikipedia.org/wiki/List_of_HTTP_header_fields#Request_fields_
- Response
  - No required headers
  - most common ones:
    - `Date`
    - `Content-Length`
    - `Content-Type`
    - `Set-Cookie`
    - _en.wikipedia.org/wiki/List_of_HTTP_header_fields#Response_fields_

- `curl -v http://www.google.com`
  - request
    ```
    GET / HTTP/1.1
    Host: www.google.com
    User-Agent: curl/7.64.1
    Accept: */*
    ```
  - response
    ```
    HTTP/1.1 200 OK               
    Date: ...
    Expires: ...
    Cache-Control: ...
    Content-Type: ...
    P3P: ...
    Server: ...
    Set-Cookie: ...
    ...

    <!doctype html><html ...>...
    ```
---
## Rack Middleware
- ***Middleware***
  - a piece of software that sits between two other pieces of software/processes and facilitates some type of data transfer between the two
  - Rack is middleware that sits between the webserver and the Rails application
- interface between application server and application framework (e.g Puma & Rails)
- A "Rack app" is an object that responds to the `#call` method
  - can be a `class` or a `proc`
  - takes the environment hash as a parameter
  - returns a response
    - array with 3 values - status code, headers, and body

### Rack Environment (env)
- contains information about the HTTP request
  - HTTP request method
  - URL information
  - server info (name, port)
- contains Rack-specific info
  - version of Rack currently being used
  - URL scheme (http/https)
  - raw HTTP data
- Rails is just a Rack app

### Rack Request && Response
- Takes Rack Environment as an argument
- These `Rack` classes are not required but:
  - provides a cleaner interface
- `Rack::Request`: generates a Rack request object
  - `Rack::Request#path`: returns the request path
- `Rack::Response`: generates a Rack response object
  - `Rack::Response#write(val)`: set the respond body
  - `Rack::Response#status=()`: set the respond status code
  - `Rack::Response#location=()`: set the path
  - `Rack::Response#[]=(key, val)`: set the response header at `key` to `val`
  - `Rack::Response#finish()`: returns the requried response array
    - [`"STATUS_CODE"`, `{HASH_OF_HEADERS}`, `[BODY]`]

- **`gem install rack`**

- require: `rack`, `byebug`

- create the app
  ```ruby
  app_name = Proc.new do
    [ '200', #status code
      {'header_key_1': header_val_1, ...}, #header hash
      ["body here"] #body
    ]
  end
  ```
- create the controller
  ```ruby
  class ControllerName
    def execute(req, res)
      ...
    end
  end
  ```
- run the app
  ```ruby
  Rack::Server.start({
    app: app_name  # application to run
    Port: ... # port to run at ([CAVEAT]: Capital P!!!)
  })
  ``` 