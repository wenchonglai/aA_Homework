
## Seeds File

The place where all the data entries are created

---
# ActiveRecord Querying

- ruby interface for querying database
- imirrors sql queries
- pros less overall database access code, more convenient

---
## Active Relation
- `ActiveRecord::Relation`
  - **Most queries DON't return Ruby objects**
    - i.e. `group`, `having`, `includes`, `joins`, `select`, and `where`
    - instead, ActiveRecord::Relation instances are returend
  - `Relation` vs. `Array`
    - ***Laziness*** - the query generating a `Relation` is not fired **until the first time the result is needed**
      ```ruby
      users = User.where(condition) #no fetch
      users.each{...}               #fetch
      users.each{...}               #cached
      ```
    - ***caching*** the Relation instance after being fetched is cached for later use; ***subsequent calls to the same method don't fire queries anymore***
    - allows for for ***chaining*** (stacking queries) - querying the stacked query will return a new Relation instance without modifying the original one
    - forcing evaluation of a `Relation`: call `#load`
---
## Scopes
- Definition
  - ***An `ActiveRecord::Base` class method that constructs (part of) a query and returns a `Relation` instance***
- keeps DRY by packaging frequently-used queries into a method
- allows for ***stacked querying***
- can be used with associations
---
## Common Querying Methods
- `#find`, `#find_by`, `#first`, `#last`, ...
  - does not return relations, returns a single Ruby object of the first matching record
  - more on Rails Guide
  - ***executes method immediately***
  - `::find` vs `::find_by`
      | |`::find`|`::find_by`|
      |-|-|-|
      |argument|id|options hash (`{col_name: val, col_name2: val2, ...}`)|
      |non-existent record|throws exception `RecordNotFound`|nil|
- `#where` / `#where.not`
  - ways of passing in conditions
    ```ruby
    XXX.where( "col_name = val")
    XXX.where( col_name: "val")
    XXX.where('col_name = (?)', "val")
    XXX.where('col_name = :var', var: "val")
    ```
    - **all of these ways prevents injection** as values are passed in for a variable only

  - more tricks on `#where`
    ```ruby
    XXX.where(col_name: a..b) #where col_name >= a and col_name <= b
    XXX.where(col_name: a..) #where col_name >= a (for Ruby 2.6 only)
    XXX.where(col_name: [...]) #where col_name in [...]
    ***.where(table_name: {col_name_1: val1, ...})
    ``` 
- `#distinct`
  - both `ClassName.distinct.select()` and `ClassName.select().distinct` work
- `#group`, `#having`
  - `#having` must be used with `#group`
- `#order`
- `#count`, `#sum`, `#average`, `#minimum()`, `#maximum()`
- `#find_by_sql(<<-SQL)`

### subquery
- subqueries can be saved in a different variable as a `Relation` instance and bu used in another query

### Showing the underliying query
- Model.do_something().to_sql

### `#count` vs. `#length` vs. `#size`
- `#count` - performs SQL query `SELECT COUNT(*) FROM...` (also forces evaluation of a query)
- `#length` - load the entire collection in to memory and conver to array, then call `Array#length`
  - **[caveat] this is EXPENSIVE!!**
- `#size` - if the collection is loaded, count the elements; otherwise, execute an additional query
---
## Querying with Associations
- `ActiveRecord` allows for calling association
- returns a `Relation` object cached inside the object model

- `joins()` / `#left_outer_joins()`
  - `ActiveRecord#joins()` allows for joining (either direct or through) association methods
    - **[caveat] Just like SQL joins, it may create duplicated values.**
  - ```ruby
    Model.joins(:attr) #Ruby; if has_many(:attr) or belongs_to(:attr) is set up
    ```
    equals to

    ```SQL
    SELECT models.* FROM models JOIN ON another_class.id = model.attr_id
    ```
  - joining potential through associations
    ```ruby
    Models.joins(:direct_assoc_method => :source_method) #if through associations not defined
    ```

  - no need to pass the name of the table
    - the passed `:attr` is an association already defined; ActiveRecord can determine which two tables are joined
- Using `select` with `joins`
  - [caveat] the keys of the return of `model.join` method defaults to the **primary table only**
  - [get-around] use `model.joins(:xxx).select("models.*, another_table.*")` to reveal other attrbutes
    - [caveat] `#inspect` only prints out attributes for the primary table
    - [get-around] use `#attributes` instead, OR
    - [ger-around] `ClassName.joins(:col_name).select(*)`
  - aliasing
    `model.join(s:xxx).select("xxx, xxx as alias_name")`
- More complex joins
  - if `has_many(:method, through: :through_method, source: source_method)` exists
    - `model.joins(:method)`
  - otherwise
    - `model.joins(:direct_assoc_method => :source_method)`
  - can also call `joins` on `ActiveRecord::Relation` objects
    - equals to `SELECT ... FROM ... JOIN ... ON ... WHERE ...`
---
## Pluck
- Accepts column names as args
- returns an `Array` instance of values of **the specified columns**
- triggers an immediate query
  - **[caveat] has to be at end of a query string**
  - other scopes must be constructed earlier
- syntax
  - `#pluck(col_name_1, col_name_2, ...)`
- code sample
  ```ruby
  Chirp.doSomething().pluck(:body)
  ```
---
## N+1 Queries Problem
- Cause: having a query action in each iteration of a loop
- [get-around]: using joins
  - creates a single query fetching all dta into a single table
  - ideally used when using aggregation on the associated data (i.e. `count`)
  - [prefered] `.joins` only saves the items specified in `.select()`; this saves memory on the client side
- [get-around]: pre-fetch the query using `#include`
  - allows us to chain onto our queries and pre-fetch associations
    - generates a 2nd query to pre-fetch the associated data
  - syntax
    ```ruby
    Model.doSomething().includes(:col_name1, :col_name2, ...)
    ```
  - code sample
    ```ruby
    # n + 1:
    self.posts.each do |post| # .post invokes a qury
      post.comments.length    # .comments invokes a query
    end

    # solution using #include
    self.posts.include(:comments).each do |post|
      post.comments.length    # :comments already invoked
    end

    #solution using #join
    self
      .posts
      .select("prim_table.*, COUNT(*) as length")
      .joins(:comments)
      .group("prim_table.id").each do |post|
        post.length
      end
    ```
- Complex includes
  - `.includes(:col_name_1, :col_name_2, ...)`
  - `.includes(:col_name => [:sub_col_name_1, :sub_col_name_2, ...])`
---