## Betterway to create ***through objects***
- if `model_a` has many `mobel_bs` and vice versa, we need to introduce `model_c` that belongs to `model_a` and `model_b`
  - Therefore `model_a`s can access `model_b`s through `model_c`s
  - [caveat] It is very cumbersome to initialize the `model_c`s one-by-one
- [workaround] `ModelA#model_b_ids`
  - the getter method
    - returns all ids of `model_b`s that `model_a` has
  - the setter method `ModelA#model_b_ids=`
    ```ruby
    model_a.model_b_ids = [...]
    ```

- `inverse_of`
  ```ruby
  class ModelA
    has_many: model_cs, dependent: destroy, inverse_of: :model_a
  end

  class ModelB
    has_many: model_cs, dependent: destroy, inverse_of: :model_b
  end

  class ModelC
    belongs_to: :model_a, :model_b
    validates :model_a, :model_b, presense: true #instead of :model_a_ids and :model_b_ids
  end

  class ModelAsController
    def strong_params
      params.require(:model_a).permit(..., model_b_ids) #allows for passing an array to params[:model_a][:model_b_ids]
    end
  end
  ```
  - in this way, a `ModelA` instance can be initialized with an array of `model_b_id`s
    ```ruby
    model_a = ModelA.new(key1: val1, key2: val2, ..., model_b_ids: [...]) 
    ```
    - before `model_a` is saved to database, `model_c` instances will be created and associated with `model_a` and the corresponding `ModelB` instances
    - once the `model_a` is saved, the associated `model_c` instances will be updated with `model_a_id`s pointing to `model_a.id`

- `ActiveRecord::Base.transaction do..end`
  - roll back all data created/modified within the `do..end` block if something goes wrong

---
## Concern
- a Rails module that allows for addiing macros, class methods, and instance methods to a Model class at the same time
```ruby
module to_be_inserted
  #turns the module to a concern
  extend ActiveSupport::Concern

  included do
    #macros go here
  end

  module ClassMethods
    #class methods go here
    def class_method_name
      ...
    end
    ...
  end

  #instance methods go here
  def instance_method
    ...
  end

  ...
end
```

---
## Polymorphic Associations
- belongs_to is associated with more than one tables
- migration
  ```ruby
  create_table table_nouns do |t|
    t.references :alias_name, polymorphic: true
  end

  # equivalent to
  
  create_table table_nouns do |t|
    t.integer :alias_id
    t.string :alias_type
  end
  ```
- model
  ```ruby
  # model/table-noun.rb:
  class TableNoun < ApplicationRecord
    belongs_to :alias_name, :polymorphic: true
  end

  # # model/table-a.rb:
  class TableA < ApplicationRecord
    has_many :table_nouns, as: :alias_name 
  end

  # model/table-b.rb:
  class TableB < ApplicationRecord
    has_many :table_nouns, as: :alias_name 
  end

  #...
  ```
- instantiation
  ```ruby
  table_noun = TableNoun.new(**options, alias_name: TableA.new)
  ```