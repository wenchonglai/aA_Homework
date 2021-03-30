# JBuilder
- simple dsl (domain specific language) tool to declare json structures
  - helps to sculpt response objs
- replaces` render json:variabl  e` of a conrollers action
  - instead, render a `json.jbuilder` file

### Common Methods
- `json.set!(key) do..end` - set a key dynamically
  ```rb
  @nouns.each do |noun|
    json.set! noun.id do
      json.keyname1 noun.keyname1
      json.keyname2 noun.keyname2
      ...
    end
  end

  #formats json into:
  #{keyname: {keyname1: value1, keyname2: value2, ...}}
  ```
- `extract!`
  ```rb
  json.extract! @noun, :keyname1, :keyname2, ...
    
  #equivalent to:
  json.keyname1 noun.keyname1,
  json.keyname2 noun.keyname2,
  ...
  ```
- `array!`
  ```rb
  json.array! @nouns, :key1, :key2

  # [ {key1:, val1, key2: val2},
  #   {key1, val1, key2: val2},
  #   ...
  # ]
  ```
- `partial!`
  - naming: `_noun.json.jbuilder`
  ```rb
  ... do 
    json.partial! 'noun', noun: @noun
  end
  ```

### Use
- In NounsController#method:`render :method`
- create `./views/api/nouns/method.json.jbuilder`
  - same as `method.html.erb`, this file has access to instance variables (i.e. `@nouns`)
- router:
  - `namespace :api default: {format: :json } do .. end`

# Organization of Redux state
- the way the Redux store is organized affects the way components and reducers are accessed

- ***Normalization***
  - [DEFINITION] a way of structuring data so there are **no duplicates** (flat state)
  - **store references** to other objects
  - purpose
    - duplicated data is hard to manage
    - given an item's ID, we can find it easily
    - avoid complex logic in reducers to handle deeply nested objects
    - avoid unnecessary re-renders of connected components
  - how to normalize
    - each type of data gets its 'table' in the state
    - POJO where keys are ids of items, and values are item objects themselves
    - any refs to other individual items should be done by store the item's ID
    - an extra array of IDs may be used to indicate ordering
  - normalizing associated data
    - data with `belongs_to` relationship stores ID of associated data
    - data with `has_many` relationship stores array of IDs of associated data
      - can use ruby's method of `xxx_ids` to fetch an array of ids of the has_many association class
    - joins table occupy their own slice of state
  - good state format
    ```js
    nouns: {
      1: {
        id: 1,
        belongsToId: 1,
        body: "...",
        hasManyIds: [1, 2, ...]
      },
      ...
    }
    ```

### Jbuilder case sensitivity
- ruby to js
  - snake_case => camelCase
- redux state follows js convention
  ```rb
  # environment.rb
  Jbuilder.key_format camelize: :lower` - conver all snake_case vars in the json file to camelcase
  ```