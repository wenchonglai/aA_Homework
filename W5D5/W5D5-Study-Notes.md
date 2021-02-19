## Active Relation
- `ActiveRecord::Relation`
  - class of the return values by querying methods such as `group`, `having`, `includes`, `joins`, `select`, and `where`
  - `Relation` vs. `Array`
    - ***Laziness*** - the query generating a `Relation` is not fired **until the first time the result is needed**
      ```ruby
      users = User.where(condition) #no fetch
      users.each{...}               #fetch
      users.each{...}               #cached
      ```
    - ***caching*** the Relation instance after being fetched is cached for later use; ***subsequent calls to the same method don't fire queries anymore***
      - good for stacking queries - querying the stacked query will return a new Relation instance without modifying the original one
    - forcing evaluation of a `Relation`: call `#load`

- `#count` vs. `#length` vs. `#size`
  - `#count` - performs SQL query `SELECT COUNT(*) FROM...` (also forces evaluation of a query)
  - `#length` - load the entire collection in to memory and conver to array, then call `Array#length`
    - **[caveat] this is EXPENSIVE!!**
  - `#size` - if the collection is loaded, count the elements; otherwise, execute an additional query

---
## ActiveRecord and Joins
- `ActiveRecord::Base::joins`
  - ```ruby
    Model.joins(:attr) #Ruby
    ```
    equals to

    ```SQL
    SELECT models.* FROM models JOIN ON another_class.id = model.attr_id
    ```

  - no need to pass the name of the table
    - the passed `:attr` is an association already defined; ActiveRecord can determine which two tables are joined
- More complex joins
  - if `has_many(:method, through: :through_method, source: source_method)` exists
    - `model.joins(:method)`
  - otherwise
    - `model.joins(:through_method => :source_method)`
  - can also call `joins` on `ActiveRecord::Relation` objects
    - equals to `SELECT ... FROM ... JOIN ... ON ... WHERE ...`
- Using `select` with `joins`
  - [caveat] the keys of the return of `model.join` method defaults to the **primary table only**
  - [get-around] use `model.join(:xxx).select("models.*, another_table.*")` to reveal other attrbutes
    - [caveat] `#inspect` only prints out attributes for the primary table
    - [get-around] use `#attributes` instead
  - aliasing
    `model.join(:xxx).select("xxx, xxx as alias_name")`
---
## N+1 Queries Problem
- Cause: having a query action in each iteration of a loop
- [get-around]: pre-fetch the query using `#include`
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
## Scopes
- Definition
  - ***An `ActiveRecord::Base` class method that constructs (part of) a query and returns a `Relation` instance***
- keeps DRY by packaging frequently-used queries into a method
- allows for ***stacked querying***
- can be used with associations
---
## Other Querying Methods
- `::find(id)` and `::find_by(hash)`
  - returns a single object
  - | |`::find`|`::find_by`|
    |-|-|-|
    |argument|id|options hash (`{col_name: val, col_name2: val2, ...}`)|
    |non-existent record|`ActiveRecord::RecordNotFound`|nil|
- `#order`, `#group`, `#having`
- `#find_by_sql(<<-SQL)`
  
