# Rails Active Record
## Initializing Rails with Postgres

### Install Rails
- **```gem install rails -v 'x.y.z'```**

### Create a new Rails project
1. **`rails new project_name -G --database=postgresql`**
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

## Migration

### Setup Database
- run **`bundle exec rails db:create`**
  - create development and test databases
  - the production database will be created when publishing to a website

### Generate Migration
- run `$rails generate migration DoSomethings`
  - generates an empty migration Ruby file with with a timestamp in **`./db/migrate`**

### Migration Commands
- table-related
  - `create_table(name, options/&prc)`
    - Code Sample
      ```ruby
      create_table :nouns do |t|
        t.string :col_1_name, # null: false, default: value,
        t.float :col_2_name #, null: false, default: value
      end
      ```
  - `drop_table(name, options)`
  - `rename_table(name_old, name_new)`

- column-related
  - `add_column(table_name, col_name, type, options)`
  - `change_column(table_name, col_name, type, options)`
  - `revome_column(table_name, col_names)`
  - `rename_column(table_name, name_old, name_new)`

### Column Datatypes
- Basic
  - string
  - text
  - integer
  - float
  - datatime/timestamp
  - data/time
  - binary
  - Boolean
- Column Options
  - limit (i.e. `:limit => 50`)
  - default (i.e. `:default => 'Null'`)
  - null (i.e. `:null => false`)
  

### Run Migration
- **`bundle exec rails db:migrate`**
  - executes run for all pending migrations not previously run
  - File **`schema_migrations`** stores the timestamp of each run migration as a record

---
## Associations

### `belongs_to` and `has_many`
- ***macro***: a class method that defines a instance method  
- `belongs_to` and `has_many` are macros
- syntax
  - `has_many(method_name_nouns, option_hash)`
  - `belongs_to(method_name_noun, option_hash)`
- **[caveat] if A has many Bs and B belongs to As, the `primary_key` for both A's and B's macros are the id of A**
- Code Sample
  ```ruby
  class Noun1
    belongs_to(
      :noun2, # reference method name
      className: 'Noun2',
      foreign_key: :prim_key_in_noun2,  # the noun2_id of noun1 instances
      primary_key: :prim_key_in_n1      # the id of noun2 instances
    )
  end

  class Noun2
    has_many(
      :noun1s, # reference method name
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
- **`[caveat]` this is different from the typical `has_may`**
- syntax
  ```ruby
  class A
    has_many(
      :bs,
      { class_name: 'B', foreign_key: :a_id, primary_key: :id }
    )
    has_many :cs, through: :bs, source: :c 
  end

  class B
    belongs_to(
      :a,
      { class_name: 'A', foreign_key: :a_id, primary_key: :id }
    )
    belongs_to(
      :c,
      { class_name: 'C', foreign_key: :c_id, primary_key: :id }
    )
  end

  class C
    has_many(
      :bs,
      { class_name: 'B', foreign_key: :c_id, primary_key: :id }
    )
    has_many :as, through: :bs, source: :a
  end
  ```

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
## Validations
- validations vs. constraints
  || ***Validations*** | ***Constraints*** |
  |---| --- | --- |
  |Definition| in ***models*** | in ***migrations*** |
  |Usage| in Ruby | in database |
  |Samples| | `NOT NULL`, `FOREIGN KEY` |
