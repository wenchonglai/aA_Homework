# Rails Active Record
### What is Rails?
- a ***server-side MVC (Model-View-Controller) web-application framework***

### ActiveRecord - an ***ORM*** Framework (the M in MVC)
- ***ORM - Object Relational Mapping***
  - a way to represent SQL data in other programming langugage 
- Allows us to:
  - represent models and their data
  - represent associations between data
  - validate models before they get persisted to the database
  - perform database operations (***CRUD (create-read-update-destroy)***) in OOP fashion

---
## Initializing Rails with Postgres

### Install Rails
- **```gem install rails -v 'x.y.z'```**

### Create a new Rails project
1. **`rails _x.y.z_ new project_name -G -d postgresql`**
  - **```-G```** : avoid creating a Github repo
  - **```--database=postgresql```** : use Postgres as the database
    - correct gems will be added
    - **```config/database.yml```** will be configured
2. Add useful gemfiles in `group :development do..end` in **`Gemfile`**
    - `gem 'annotate'`: add helpful coments to models by **```bundle exec annotate```**
    - `gem 'better_errors'`, `gem 'binding_of_caller'`: error handling tools
    - `gem 'byebug`
    - `gem 'pry-rails'`: interactive Ruby environment
3. run **`bundle install`**

- [trick] ***fuzzy typing*** use `cmd + P` and type the file name to access the actual file

---
### Switch from SQLite to Postgres
1.  rm -rf ./db/.sqlite3
2.  change `gem 'sqlite3'` -> `gem 'pg` in **`Gemfile`**
3.  **`bundle install`**
4.  Edit **`config/database.yml`**
    1.  change the default environment
        ```yml
        default: &default
          adapter: postgresql
          pool: 5
          timeout: 5000
        ```
    2.  create a database and properly name the dev, test, and prod databases
        ```yml
        development:
          <<: *default
          database: project_name_development
        ```
---

## Migrations

### Overview
- *Incremental* and *reversable* changes made to a ***database schema***, allowing for evolution over time
- Ubiquitous to app frameworks that work with relational DBs
- Rail allows for easier Ruby ***DSL (domain-specific language)*** to describe changes to tables

### Setup Database
- run **`bundle exec rails db:create`**
  - create development and test databases
  - the production database will be created when publishing to a website
- Drop Database
  - run **`bundle exec rails db:drop`**

### Generate Migration

- run `$bundle exec rails g migration Action`
  - ***[caveat] ALWAYS use `bundle exec` so that it is using the correct version of Rails***
  - Action naming convention
    - `Create{TableNouns}`
    - `Add{ColumnName}To{TableNouns}`
    - `Remove{ColumnName}From{TableNouns}`
    - `AddIndexTo{TableNouns}`
  - generates an empty migration Ruby file with with a timestamp in **`./db/migrate`**

### Migration Commands
- table-related
  - `create_table(name, options/&prc)`
    - Code Sample
      ```ruby
      create_table :table_nouns do |t|
        #the database constraints option hash is optional, but HIGHLY RECOMMENDED
        t.string :col_1_name, {null: false, default: value}, 
        t.float :col_2_name, {null: false, default: value},
        ...
        t.timestamps # keeps track of when a piece of data is created
      end
      ```
  - `drop_table(name, options)`
  - `rename_table(name_old, name_new)`

- column-related
  - `add_column(table_name, col_name, data_type, options)`
  - `change_column(table_name, col_name, data_type, options)`
  - `revome_column(table_name, col_names)`
  - `rename_column(table_name, name_old, name_new)`
- index-related
  - `add_index(table_name, :col_name, options)`
    - add index to a column to **speed up querying** 
    - ***[caveat] ALWAYS add index to foreign keys!***
    - ***[caveat] also think about whether a foreign key is unique***
      - if it is unique, include `unique: true` in the option hash
  - `remove_index`

### Column Datatypes
- Basic
  - `string` (0-255 characters)
  - `text`  (any characters)
  - `integer`
  - `float`
  - `datatime`/`timestamps`
  - `data`/`time`
  - `binary`
  - `Boolean`
- Column Options
  - limit (i.e. `:limit => 50`)
  - default (i.e. `:default => 'Null'`)
  - null (i.e. `:null => false`)
  

### Run Migration
- **`bundle exec rails db:migrate`**
  - executes run for all pending migrations not previously run
  - File **`schema_migrations`** stores the timestamp of each run migration as a record
- **`bundle exec rails db:migrate:status`**
  - check migration status

### Changing existing Migrations
- ***[caveat] DO NOT delete any migration files!!!***
- two options
  - write a new migration (much preferred)
  - rollback:
    
    ***[caveat] Very Dangerous While Working with Others!!!***
    1. rollback the migration (via `rails db:rollback`)
    2. edit the migration
    3. run `rails db:migrate` again
---
## Model
- the M of the MVC Pattern
- a class that represents and directly manages the data, logic, and rules for a table
  - typically contains: ***validations***, ***associations***, custom methods
  - inherits from ApplicationRecord < ActiveRecord
- **one-to-one** correspondence between a model and a table
  - a model class is a table
  - an instance of that model class is a row in the table

### generate a model
- [trick] **`bundle exec rails g model {ModelName}`**
  - sets up BOTH model file and the migration file

---
## Validations
### Validations vs. Constraints
- **BOTH are necessary**
- comparisons
  || ***Validations*** | ***Constraints*** |
  |---| --- | --- |
  |Definition| in ***models*** | in ***migrations*** |
  |Usage| in Ruby | in database |
  |Samples| | `NOT NULL`, `FOREIGN KEY` |
  |null prevention|`presence: true`|`null: false`|
  |unique values|`uniqueness: true`|`unique: true`|
  ||best used to provide error msgs to users interacting with the app|last line of defence|

### Validation
- annotating models
  - `bundle exec annotate --models`
- `#valid`
  - When `#save` or `#save!` is called, ActiveRecord calls the `#valid?` method.
- errors
  - use the `#errors` method after `#valid?`, `save`, or `save!` to inspect errors
  - `instance.errors` - shows all active errors pertaining to that instance
- syntax
  ```ruby
  validates(:col_name_1, :col_name_2, ... {
    validator_1: val,       
    validator_2: {            #option hash
      message: "...",         #saves message to error if validtion fails
      allow_nil: true/false,  #skips validation if value being validated is nil
      allow_blank:            #skips validation if value being validated is blank

      #option for uniqueness
      scope: :col_name, 

      #options for length
      minimum: n1,      
      maximum: n2,

      #option for inclusion
      in: [val_1, val_2, ...],

      #options for numericality
      greater_than: n1,
      greater_than_or_equal_to: n2,
      less_than: n3,
      less_than_or_equal_to: n4
    }
  })
  ```

### Built-in Validators
- _https://guides.rubyonrails.org/v4.0.0/active_record_validations.html#common-validation-options_
- `presence`
  - calls `#blank?` to validate the specified attributes are not empty
- `uniqueness`
  - validates the attribute's value is unique
  - can take a hash as the value:
    ```ruby
    class A < ApplicationRecord
      validates :col_name, uniqueness: {
        scope: :year,
        message: 'validates the uniqueness of col_name for a single year'
      }
    end
    ```
- other
  - `format` - whether a string matches regexp
  - `length` - whether a string/array has appropriate length
    - `length: {minimum: , maximum}`
  - `numericality: {greater_than/greater_than_or_equal_to, less_than/less_than_or_equal_to}`
  - `inclusion: {in: }`
- **[caveat] classes with `belongs_to` macro(s) are automatically validated. To remove this feature, add `optional true` in the `belongs_to` macro**

### Custom Validations
- Custom Methods
  - define custom private method in the model class and use that method in `validate:`
  - syntax
    ```ruby
    validate: col_name, validation_method, **options
    ```
  - ***[caveat] for custom validations, it is `validate`, NOT `validates`!!!***
  - code sameple
    ```ruby
    class Noun < ApplicationRecord
      def validation_method
        errors[:col_name] << 'message' unless ...
      end
    end
    ```
- Custom ***Validators***
  - use when the same validation logic needs to be reused
  - code sample
    ```ruby
    class ColumnNameValidator < ActiveModel::EachValidator
      def validate_each(record, col_name, value)
        #calls EachValidator#options to access custom message
        message = options[:message] || 'default message'
        record.errors[:col_name] << message
      end
    end

    class Noun < ApplicationRecord
      validates: :column_name, column_name: true
    end
    ```
---
## Associations
- Connections between two ActiveRecord models
- Makes common opeartions simpler and easier
- avoids using SQL `JOIN` statements
- creates simple methods

### `belongs_to` and `has_many`
- ***macro***: a class method that defines a instance method  
- `belongs_to` and `has_many` are macros
- syntax
  - `has_many(method_name_nouns, option_hash)`
  - `belongs_to(method_name_noun, option_hash)`
    - syntatic sugar
      ```ruby
      belongs_to :noun,
        foreign_key: :noun_id,
        class_name: :Noun
      
      # equals to

      belongs_to :noun
      ```
- **[caveat] if A has many Bs and B belongs to As, the `primary_key` for both A's and B's macros are ALWAYS the id of A**
  - the class with `belongs_to` contains the foreign key
- **[caveat] validation of `presence: true` automatically runs for the foreign key of an instance with `belongs_to` association!**
  - [get-around] add `optional: true` to the `belongs_to` macro
- Code Sample
  ```ruby
  class Noun1
    belongs_to( :noun2, # reference method name
      className: 'Noun2',
      foreign_key: :prim_key_in_noun2,  # the noun2_id of noun1 instances
      primary_key: :prim_key_in_n1,     # the id of noun2 instances (omittable)
      optional: true                    # (if desired)
    )
  end

  class Noun2
    has_many( :noun1s, # reference method name
      className: 'Noun1',
      foreign_key: :noun2_id,           # the noun2_id of noun1 instances
      primary_key: :id                  # the id of noun2 instances
    )
  end
  ```
- usage
  ```ruby
    noun1.noun2 # => return the noun2 that noun1 belongs to
    noun2.noun1s # => return all noun1s that noun2 has
  ```

### `has_many :through`
- `add_index(table_name, [:col_name1, :col_name2], {unique:true})`
  - add a unique constraints on two columns to ensure there cannot a same set of values
- **`[caveat]` this is different from the typical `has_many`**
- **`[caveat]` make sure to validate the uniqueness of the foreign keys in the intermediate class!!!**
- [note]: there can be more than one through classes
- syntax
  ```ruby
  class A
    has_many( :bs,
      { class_name: 'B', foreign_key: :a_id, primary_key: :id }
    )
    has_many(:cs, {
      through: :bs, #instance method in A
      source: :c    #intance method in B
    })
  end

  class B
    # make sure to validate the uniqueness of a_id and b_id
    validates(:a_id, {
      uniqueness: {
        # a_id must be unique with the given b_id
        scope: :b_id,
        message: 'error message'
      }
    })
    belongs_to( :a,
      { class_name: 'A', foreign_key: :a_id, primary_key: :id }
    )
    belongs_to( :c,
      { class_name: 'C', foreign_key: :c_id, primary_key: :id }
    )
  end

  class C
    has_many( :bs,
      { class_name: 'B', foreign_key: :c_id, primary_key: :id }
    )
    has_many :as, through: :bs, source: :a
  end
  ```
### has_one
- easily confused with `belongs_to`
- only wrte them if the corresponding belong_to is made

### ***Reflexive Associations***
- code sample
  ```ruby
  class A
    has_many(
      :a_children,
      {class_name: A, foreign_key: parent_id, primary_key: id}
    )
    belongs_to(
      :a_parent,
      {class_name: A, foreign_key: parent_id, primary_key: id}
    )
  end
  ```
### ***Two Associations to the Same Class***
- code sample
  ```ruby
  class A
    has_many(
      :type1_bs,
      {class_name: B, foreign_key: type1_id, primary_key: id}
    )
    has_many(
      :type2_bs,
      {class_name: B, foreign_key: type2_id, primary_key: id}
    )
  end

  class B
    belongs_to(
      :type1_as,
      {class_name: A, foreign_key: type1_id, primary_key: id}
    )
    belongs_to(
      :type2_as,
      {class_name: A, foreign_key: type2_id, primary_key: id}
    )
  ```
---
