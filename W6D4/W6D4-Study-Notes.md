# CSS
## Position
- `Static`
  - default positioning and flow of elems
  - things flow around each other
  - things take space
  - Does **NOT** react to the top, bottom, left or right properties
- `Relative`
  - relative to where it would be
  - remains the same
  - reacts to the t/b/l/r properties
- `Absolute`
  - positions relative to nearest non-static ancestor
    - uses the document if everything is static
  - no longer takes up space in page
  - reacts to the t/b/l/r properties
- `Fixed`
  - same as absolute but relative to viewport
  - good for navbars
- `sticky`
  - combination of `fixed` and `relative`
  - t/r/b/r relative to the viewport
  - will take up space until scolling past it, then it 'sticks' to the viewport
    | |`static`|`relative`|`absolute`|`fixed`|`sticky`|
    |-|-|-|-|-|-|
    |in the flow (orig. space is occupied even when moved)|yes|yes|no|no|yes until scolled past|
    |reacts to top/bottom/left/right|no|yes|yes|yes|yes|
    |relative to|-|itself's orig. position|nearest non-static ancestor|viewport|viewport, but within the nearest non-static ancestor|

## Dropdowns
- hover effect on an element displayins a "dropdown" list of elements
- hover effect from `display:none` to `display: block`
- the list of elems appear on top of the rest of the page due to position: absolute

---
# Routing & Controllers Continued
### ***Callbacks***
- methods get called at a certain moment of an object’s life cycle
- types
    - `dependent`
    - `before_validation`
    - `after_create`
    - `after_destroy`
---
### ***DNS - Domain Name System***
- ***name server*** vs. ***DNS resolver***
  - ***name server*** - a set of distributed directory service
    - holders of information
  - ***DNS resolver***
    - lookers-up of information
- querying for a domain name - how it works
    1. query sent from a DNS resolver to a DNS name server
    2. the name server:
        1. delivers a result if necessary info is stored locally, OR
        2. the name server passes the query onto another name server, or return to the resolver the IP address of another name server that might have the appropriate info 
- ***cache poisoning*** - a common ***DNS attack*** in which attacker tries to replace valid cache entries with corrupted data
---
### JSON API
- JSON is a better format for non-browser clients
- in Rails
    - Model: needs to convert a model to JSON via `xxx.to_json`
    - Controller: needs to return the JSON to user via `render(:json =>xxx)`

Nested routes
- ***collection routes***
    - includes :index, :new, and :create
    - nesting
      ```ruby
      resources :item_1s do
        resources :item_2s, only: :method_name, …
      end

      resources :item_2s
      ```
    - generates a route of `/item_1s/:item_1_id/item_2s`
    - **[caveat] :new should not be nested**
- ***member routes***
    - include :show, :edit, :update, and :destroy
    - **[caveat] member routes should never be nested**

Non-Default Routes
- adding ***member routes***
    - [example] routing `GET /nouns/:id/verb` to `NounsController#verb`:
        - ```ruby
          resources :nouns do
            member { get ‘verb’ }
          end
          ```
- adding collection routes
    - [example] routing `GET /nouns/verb` to `NounsController#verb`:
