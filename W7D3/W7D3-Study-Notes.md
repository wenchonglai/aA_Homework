# Rails Testing
- Rail's MVC components match up nicely with the testing pyramid
  - Models - Typically Unit tests
  - Controllers - Typically Integration Tests
  - Views - Typically E2E Tests
---
## Setup Rails Testing
- Useful Gems
  - development & test
    - `pry-rails`
    - `rspec-rails`
      - Configuration
        - **`rails g rspec:install`**
        - automatically generate test files
        - ```ruby
          #.config/application.rb
          config.generators do |g|
            g.test_framework :respec,
              :fixtures => false,
              :view_spes => false,
              :helper_specs => false,
              :routing_specs => false,
              :controller_specs => true, # auto-generate spec file when generating a controller
              :request_specs => false

            g.fixture_replacement :factory_bot, :dir => "spec/factories" #easier fixture replacement and automatic creation of instances
          end
          ```
    - `factory_bot_rails` - automatic generation of model instances
    - `rails-controller-testing`
    - `spring`
      - rails application pre-loader; speeds up dev by keeping the app running in the background
  - test
    - `faker` - generate random data
    - `capyabara` - test views & features within the application
        - need to manually create `./spec/features` for Capybara helper methods
    - `spring-commands-rspec`
      - allows for Spring reloading when running RSpec tests
    - `guard-rspec`
      - monitors the specified change of files
    - `shoulda-matchers` - allows for one-liner tests for validations and associations
      - configuration
        ```ruby
        #rails_helper.rb
        require 'shoulda/matchers' #IMPORTANT!

        Shoulda::Matchers.configure do |config|
          config.integrate do |with|
            with.test_framework :rspec
            with.library :rails
          end
        end
        ```
        - **[caveat] Remember to `require 'shoulda/matchers'`!!!**
    - `launchy` - launch external applications from within the Rails app
---
## Testing Models with Rspec
- model testing is ***unit testing***
- [location] **`./spec/models/`**
-`shoulda-matchers` methods
  - [reference] _https://github.com/thoughtbot/shoulda-matchers#table-of-contents_
- 
- components
  - `model_noun.valid?`
    - test if a model instance is valid
    - `be_valid` assertion
      - `expect(model_noun).to be_valid`
  - validations
    - `validate_presence_of(:col_name)`
    - `validate_uniqueness_of(:col_name)`
    - custom validation code sample
      ```ruby
      it "should validate ..." do
        table_noun = TableNoun.new(...)
        table_noun.valid?
        expect(table_noun.errors[:xxx]).to eq(["..."])
      end
      ```
  - associations
    - `belong_to(:assoc_method)`
    - `have_many(:assoc_method)`
    - `have_one(:assoc_method)`
    - `have_many(:source_method).through(:through_method)`
  - methods
  - error messages
    ```ruby
    table_noun.valid?
    expect(table_noun.errors[:xxx]).to eq(["..."])
    ```
- **[caveat] test ActiveRecord methods such as `where_values_hash` and `order_values` to avoid actually querying the database**
---
### Factory Bot & Faker
- Purpose: to auto-create instances for testing
- location: './spec/factories'
- ```ruby
  FactoryBot.define do
    factory :table_noun do
      col_name_1 { Faker::xxx.xxx }
      col_name_2 { Faker::xxx.xxx }
      ...
      factory :table_noun_2 do
        ...
      end
    end
  end
  ```
- `FactoryBot::build` vs. `FactoryBot::create`
  - `FactoryBot::build` creates a new instance
  - `FactoryBot::create` creates a new instance **and saves it into the database**
- the nested `factory do..end` blocks allows for assignments in the inner scope to **overwrite** the assignments in the outer scope
- **[caveat]: use a block `{}`, (NOT `()` parentheses)** after the column name to make sure every time the faker string created is different
- Faker classes and methods
  - _github.com/stympy/faker_
- Generating instances using FactoryBot
  - `FactoryBot.build(:table_noun, option_hash)`
---
## Testing Rails Controllers
### What to test
- **Status codes** and **responses** in various conditions
- valid and invalid **params**

### Rspec Rails API
- Navigation
  - `get`, `post`, `patch`, `delete`
  - can past in params
- Assertions
  - `render_template`
  - `redirect_to`
  - `have_http_status`
  - `be_success`
- code sample
  ```ruby
  RSpec.describe TableNounsController, type: controller do
    describe "GET #index" do
      it "..." do
        get :index
        expect(response).to have_http_status(xxx)
        expect(response).to render_template(:index)
      end
    end
  end
  ```
- [caveat] cannot write tests for private methods

---
## Capybara: Testing Rails Features
- ***Feature*** The process starting from user making an action to the server sending back response to the user

### Capybara API
- syntax
  - _https://rdoc.info/github/jnicklas/capybara/Capybara_
  - Navigation
    - `visit("request_path_here")`
    - `click_on()`
      - `click_on("link text")` <==> `click_link("link text")`
      - `click_on("button value")` <==> `click_button("button_value")`
  - Forms
    - `fill_in "lable_for_or_input_name_str", with: "value"`
    - `choose`, `check`, `uncheck`
    - `select "option", from: "select box"`
  - Assertions
    - `have_content`
    - `current_path`
    - `page`
  - Debugging
    - `save_and_open_page`
      - saves the scenario action and open the HTML page
- helper methods
  - can be appended to `spec_helper.rb`
- location
  - `./spec/features`
- code sample
  ```ruby
  feature "capybara features", type: feature do
    feature "doing something" do
      before (:each) do
        visit "route"
      end

      scenario "..." do
      end

      scenario "..." do
      end
    end
  end
  ```
---
Rspec View Tests
- location
  `./spec/views`
- naming
  `xxx.html.erb_spec.rb`
- syntax
  ```
  Rspec.describe "view_name_folder/template_name" do
  end
  ```
  - `assign(:instance_var_name, [*instances])`
  - `render` - render the assigned `@instance_var_name`
  - assertions
    - `match` - `expect(rendered).to match /regexp_here/`
    - `have_link` - `expect(rendered).to have_link "link text", href: "link_url"`