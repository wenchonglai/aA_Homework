# ***AJAX - Asynchronous Javascript and XML***
- [DEFINITION] An HTTP request made in the background
- AJAX vs. normal XMLHTTP request
  - HTTP response returns the entire new page
  - AJAX response returns data only
- when a AJAX request completes:
  - the broswer ***will note*** load a new page
  - instead, the browser will fire a JS callback function
- allows for:
  - request and receive data **after** a page has loaded
  - send data to the server **in the background**
  - send and render data as `json`
  - backend becomes a server-side API
- ideal for Single-Page Web app
  - client-side rendering (through React)

### AJAX Process
1. event occurs on a webpack
2. an XMLHttpRequest object is created and sends a request to the web server
3. server processes the request
4. server sends a response back
5. JS performs proper action 

### jQuery AJAX methods
- `$.ajax`
  - allows for making AJAX request
    - returns a `promise`
    - any data format can be used
  ```js
  $.ajax({
    url: '...',
    //type is an alias of method
    method: 'REQUEST VERBS', // default: 'GET'
    dataType:, //i.e. JSON
    data:,  // the HTTP body
    success: success_callback_func(data){},
    error: error_callback_func(errMsg){}
  });
  - low level, complete interface
- `$.get`
- `$.post`
- akin to JS's `XMLHttpRequest` or `fetch`

### jQuery Remote Forms
- ```js
  $('form-name').on('submit', e => {
    e.preventDefault();

    let formData = $(e.currentTarget).serialize();

    $.ajax({
      url: ...,
      type: ...,
      data: formData,
      success(){...}
    })
  });
  ```
- `$.prototype.serialize`
  - serializes the form elements into URL encoded string
  - difficult to read
  - will need to add hidden inputs or append more URL encoded strings if additional data needed
- the `$.prototype.serializeJSON` plugin
  - _https://github.com/marioizquierdo/jquery.serializeJSON_
  - converts the form elements into a JS object following Rails parameter conventions
  - server-side setup
    `gem 'serialize_json-rails'` - have Rails authomatically load the serializeJSON plugin
  - client-side setup
    ```js
    // app/assets/javascript/application.js
    require serialize_json
    ```

## jQuery and Rails
- [NOMENCLATURE] ***payload*** - data passed as parameters
- `gem 'jquery-rails'`
- Sprockets
  - _https://github.com/rails/sprockets_
- npm install
  - allows for the use of webpack
- authenticity token
  - Rails will automatically include a JS library named `rails.js` in `application.js`, which will install a `$.ajaxPrefilter` that runs before every AJAX request
  - this filter will look up the CSRF token and add it as a header along with the request
  - `$(meta[name="csrf-token"]).attr('content')` - explicitly look up the CSRF token

---
# Promises
- represent the **eventual** **completion or failure** of an **asynchronous** operation and its resulting value
- a promise is an object that wraps an **action** ,which is the task (typ. asynchronous) it is supposed to perform before it either fails of succeeds based on some **constraint**
- allows complex asynchronous code to be more readable

### States of a Promise
- ***`Pending`*** - the promise's action is ongoing (hasn't fulfilled or rejected yet)
- ***`Settled`*** - the promise's aciton has finished (either fulfilled or rejected)
  - ***`Fulfilled`*** - the proimse's action succeeded
    - success callback in `then` will run
  - ***`Rejected`*** - the promise's action failed
    - failure callback in `then` or `catch` will run

### Promise API
- `then` is the most important Promise method
  - takes a success callback and (optionally) a failure callback as args
  - returns a new promise
  - can chain `then` as many times as you want
- A promise chain stops if: 
  1) there's an exception and looks for failure callback in the next `then`
  2) if there is none, down the chain for a `catch`
- `catch` takes a failure callback and is used for error handling; also returns a promise
---
# server-side web API
- [DEFINITION] a programmatic interface consiting of one or more publicly exposed endpoints to a **defined request-response message system**; typically expressed in JSON or XML, which is exposed via the web (most commonly by means of an HTTP-based web server)
- Number of Web APIs up from 105 in 2005 to over 9000 in 2013

---
