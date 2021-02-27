# Rails View

- the client-facing portion of Rails
- comprises the multiple types of response from the controller
  - i.e. webpage(HTML) vs. web service (JSON/XML, etc)
- web page or `Template` composition
  - HTML
  - CSS
  - Javascript

### Controller Rendering
- Views - JSON, HTML
- Syntax
  - ```ruby
    ## all of the following are equivalent
    render :view_name
    render 'viewname'
    render template: "nouns/view_name"
    render template: "nouns/view_name.html.erb"
    ```
  - If it is in `NounsController` methods, rails will look the view file `./views/nouns/view_name.html.erb`
- shortcut
  - if using RESTful methods, the `render` can be omitted and Rails will automatically render **`/views/noun/restful_method_name.html.`**

### Application View
- when rendering views, it will render the specified template within **`application.html.erb`**
  - all user .erb views will inherit from `./views/layouts/application.html.erb` just as `NounsController` inherits `ApplicationController`
  - the user template is going to interpolate and be rendered at the tag `<%= yield %>`

### ***embedded ruby (ERB)***
- HTML templates augmented with Ruby Code
  - allows for use ruby code in html
- passing parameters into ***.erb*** 
  - **instance variables** defined in the **controller action method** will be passed to the view file
- syntax
  - `<% ruby code to be executed but not rendered goes here%>`
  - `<%= ruby code to be rendered goes here%>`
- code sample
  ```erb
  <ul>
    <% @instance_arr_name do |el|%>
      <li><%= el.val %></li>
    <% end %>
  <li>
  ```
- commenting out erb ruby codes
  ```erb
  <%# lorem ipsum %> #OR
  <%#= lorem ipsum to be printed%>
  ```
  - [caveat] the html comment format `<!-- -->` will not work for `<% %>` and `<%= >` tags
- `link_to` and `button_to`
  - erb methods to generate `a` tags for `GET` or `form` tags for `POST` / `PATCH` / `DELETE`
    ```erb
    <%= link_to 'Title Name', "url_str" %>
    <!-- or -->
    <%= link_to 'Title Name', prefix_url %>
    <!-- generates -->
    <a href="url_str"> Title Name </a>

    <%= button_to 'Title Name', url_method(arg), method: http_method>
    <!-- generates -->
    <form action="<%= url_method(arg) %>" method='POST'>
      <input type="hidden" value="http_method" name="_method">
      <input type="submit" value="Title Name"/>
    </form>
    ```
- [caveats]
  - ERB code is NOT visible to the client/browser
  - Do NOT run `puts` or `print`

---
## HTML parameters <==> Rails parameters
- Hash
  After submitting:
  ```html
  <input name="primary_key[sub_key1][sub_key2]" value="val">
  ```
  `params` will contain:
  ```ruby
  { "primary_key" => { "sub_key1" => { "sub_key2" => "val" } } }
  ```
- Array
  After submitting:
  ```html
  <input name="primary_key[sub_key][]" value="val1">
  <input name="primary_key[sub_key][]" value="val2">
  <input name="primary_key[sub_key][]" value="val3">
  ```
  `params` will contain:
  ```ruby
  { "primary_key" => {
      "sub_key" => {
        "val1",
        "val2",
        "val3",
      }
    }
  }
  ```
- **[caveat] cannot make arrays of hashes**
  - [work-around]
    ```html
    <input name="primary_key[][sub_key]" value="val1">
    <input name="primary_key[][sub_key]" value="val2">
    <input name="primary_key[][sub_key]" value="val3">
    ```
    `params` will contain:
    ```ruby
    { "primary_key" => {
        "0" => { "sub_key" => "val1" }
        "1" => { "sub_key" => "val2" }
        "2" => { "sub_key" => "val3" }
      }
    }
    ```
---
## Using Forms
- [caveat] `comment out protect_from_forgery with: :exception` in **`./controllers/application_controller.rb`** to prevent authentication error
- Nesting the param keys
  - `<input name='prime_key[sub_key]'>`
  - the name should match the strong params
- receiving HTML form parameters
  - use `params` in the Controller method
- handling successful cases
  - `if nouns.save redirect_to noun_url(@noun)`
- handling fail cases
  - `else render :new`
- **[caveat] use a private method to ensure *strong parameters* to avoid malicious data**
- changing form method from `POST` to `PATCH`
  - [caveat] html browsers area only designed for `POST` and `GET` methods
  - [work-around] **use `POST` as the form method**, **AND** add a hidden tag in the form
    - `<input type="hidden" name="_method" value="PATCH>`
    - this hidden input sends the real method in the param to the server

---
## Partials
- intent
  - keep the code DRY
- adding a partial file
  - `./views/nouns/_partial_name.html.erb`
    - naming convention: include an underscore at the beginning of the file name
- invoking the partial
  ```erb
  <%= render 'sub_folder_name/partial_name', arg_name_1: value_1, arg_name_2: value_2, ... %>
  <%# pulls in the partial from ./app/views/sub_folder_name/_partial_name.erb %>
  ```
  - [caveat] pass the instance variables to the partial as arguments
  - [caveat] don't include the underscore
  - [caveat] use string for the partial name; do **NOT** use symbol
- Rendering Collections
  - ```erb
    <%= render nouns %>
    <%# is equivalent to %>
    <% @nouns.each do |noun| %>
      <%= render noun %>
    <% end %>
    <%# is equivalent to %>
    <% @nouns.each do |noun| %>
      <%= render 'noun', noun: noun %>
    <% end %>
    ```
- **[caveat] do NOT use instance variables in partials**
---
## Debugging Rails
### Routing Errors
- compare the actual url vs. the expected url
- look at the server log
  - url
  - status
  - parameters
### Controller Errors
- include these gems in **`./Gemfile`**'s development group and **`bundle install`**
  - `gem 'pry-rails'`
  - `gem 'better_errors'`
    - gives better stack trace
  - `gem 'binding_of_caller'`
    - opens an interactive REPL in the browser when the code crashes
  - use `fail` in the controller code to invoke the debugging controller
    - this is akin to `debugger` in `bye-bug`
  - use `debugger` in the model code
    - **[caveat] do NOT include `require 'bye-bug'`**
    
