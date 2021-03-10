## ActioMailer
- Allows users to send emails from an application

### `ActionMailer::Base`
- works similarly as `ApplicationController::Base`
- Mailer intances live in **`./app/mailers`**

- Create a Mailer
  - **`rails generate mailer MailerName`**
    - creates the mailer, the views, and the tests
      - mailer file: `./app/mailers/mailer_name.rb`
      - view file: `app/views/mailer_name`
- Edit the Mailer
  - add methods in the `MailerName` class
    - `#mailer_method_name(user)`
  - `mail(to: [*email_address_strs], subject: 'text here')`
    - the `from` attribute is defaulted in each Mailer class
    - `cc` and `bcc` can also be set
    - the name of the recipient can be included in `email_address_str`
      i.e. `App Academy <contact@appacademy.io>`
    - returns a `Mail::Message` instance
      - it it doesn't mail it through, the caller of the Mailer method will then call the the `Mail#deliver_now` method
- Create a Mailer View
  - in **`./app/view/mailer_class_name/`**:
    - create a **`mailer_method_name.html.erb`**
      - **[caveat] the HTML email may get into spam if there is the text version is absent**
    - also create a text version **`mailer_method_name.text.erb`**

### Other common methods
- adding attachments
  `attachments['attachment_name.xxx'] = File.read('file_name.xxx')`
- Generate URLs in Action Mailer Views
  - the mailer instance doesn't have context about incoming request
  - will need to provide the `:host` parameter manually
  - the default host can be configured in `./config/`:
    ```ruby
    # app/config/environments/development.rb
    config.action_mailer.default_url_options = { host: 'localhost:3000' }

    # app/config/environments/production.rb
    config.action_mailer.default_url_options = { host: 'www.production-domain.com' }
    ```
  - [caveat] the `prefix_path` helper cannot be used within an email
    - [work-around] use `prefix_url` instead
      ```erb
      <%= link_to 'welcome', welcome_path %>  # does not work
      <%= link_to 'welcome', welcome_url %>   # works
      ```

### Letter Opener
- A gem for development environment email testing
  - `gem 'letter_opener', group: :development`
- change the `deliver_method` in `./config` file:
  ```ruby
  # config/environments/development.rb
  config.action_mailer.delivery_method = :letter_opener
  ```

### **[caveat] Mailing is Slow**
- [work-around] batch up and send emails offline
---
## ***View Helpers***
- Ruby methods that can be called from the view
- purpose: to hold view-specific code that DRYs up templates
- common view helpers
  - `link_to`
  - `button_to`
  - `form_for` (for building forms)
  - `javascript_include_tag` (for including assets)
- location of user-defined helpers
  `app/helpers/controller_name_helper.rb`
- syntax
  ```ruby
  module ApplicationHelper
    def method_name(text)
      "<tag_name>#{h(text)}</tag_name>".html_safe
    end
    def method_name_2(obj)
      html = "<tag_name>
              <tag_name_2 attr_1=\"#{obj}\" attr_2=\"#{h(obj)}\">
              </tag_name>"
    end
  end
  ```

### Escaping HTML
- **[caveat] HTML strings that print into an erb will be escaped**
  - `h(text)`
  - purpose: if not escaped, html texts could cause ***HTML injection***
- `String#html_safe` - a method that Rails monkey-patched to the String class to bypass escaping
  - [caveat] ALWAYS use `h(text)` along with `#html_safe` to avoid user input causing ***html injection***

### Capturing a block in erb
  - `capture(&block)`
    - converting an erb block to text to be included in another erb

---
## Layouts
- the rendered Rails template will be inserted into a ***layout***
- layout location
  - **`./app/views/layouts/`**
- `<%= yield %>`
  - identifies a secton where content from the view should be inserted
  - multiple yielding is possible by inserting differnt yield tags
  - named yield block: `<%= yield :named_content%>`
    - `<% content_for :name_content%>..<% end %>` allows for inserting the block into the named `<%= yield %>` block
- ***asset tags***
  - javascript_include_tag "js_file_name"
  - stylesheet_link_tag "css_file_name"