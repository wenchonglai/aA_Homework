# DOM - ***Document Object Model***
- An API for accessing the HTML content
- standardized by ***World Wide Web Consortium (W3C)***
- supported by all major browsers
  - *with slight variations*

### Accessing HTML Elements
- `document.getElementById(id)`
- `document.getElementsByClassName('classname')`
- `document.querySelectorAll('css selector string')`

## Events
- `EventTarget` - ***parent class*** of `HTMLElement`
- `EventTarget.prototype.addEventListener('eventName', callbackFunction)`
- common events
  - `click`, `dblclick`
  - `input`, `change`, `submit`
  - `keydown`, `keyup`
  - `mousemove`, `mouseover`, `mouseout`
  - `scroll`, `resize`
  - _https://developer.mozilla.org/en-US/docs/Web/Events_

---

# jQuery
- the jQuery library exports two global variables - `$` and `jQuery`; `jQuery === $`

## Selection & Manipulation

## Selection
- `$('css selector string')`
  - similar to `document.querySelectorAll('css selector string')`
  - returns a ***jQuery object***
    - a ***jQuery object*** is fundamentally an array of ***HTMLElements***

### Explicit and Implicit Iteration
- `$.prototype.each` - ***explicitly*** iterates through the list of `HTMLElements`
- ***implicit iterations*** - methods that implicitly iterates through a ***jQuery object*** (a collection of HTMLElements)
  - `$.prototype.addClass`, `$.prototype.removeClass`,   `$.prototype.toggleClass`
  - `$.prototype.attr(attr_name, "attr val")`

### Inserting/Removing Elements
- `$.prototype.append(htmlElement)`
- `$.prototype.remove()`
  - implicit iteration

### Creating DOM Elements
- ```js
  const $var = $("<tag_name></tag_name>");
  $var.text(...);
  $var.attr(...);
  $parentElement.append($var);
  ```
- `$(htmlElement)` - creates a jQuery object wrapping the `htmlElement` being passed

### Getters and Setters
- ||getter|setter|
  |-|-|-|
  |`attr`|`$.prototype.attr(name)`|`$.prototype.attr(name, val)`|
  |`text`|`$.prototype.text()`|`$.prototype.text(val)`|
  |`val`|`$.prototype.val()`|`$.prototype.val(val)`|

### Traversal
- `$.prototype.parent`, `$.prototype.children`, `$.prototype.siblings`

## Events
- `$.prototype.on(eventName, callback)`
- stop listening:
  `$.prototype.off(eventName, callback)`
- `Event.prototype.currentTarget`
  - returns the current `HTMLElement` target of the event
- `$(event.currentTarget)` - create a jQuery element that wraps the currentTarget of the event
- `Event.prototype.preventDefault`
  - avoids triggering any built-in actions
  - [IMPORTANT] most important for form submit events

## Ready
- [CAVEAT] `<script>` tags are immediately executed before the rest of the HTML document is parsed
  - **HTML elements cannot be queried before they are initialized**
- the `$` selector may return an empty jQuery object if the document is not ready
  - [CAVEAT] **No errors will be rased**

### ensuring JS Code will be executed only after the page is loaded
- **[CAVEAT] NOT RECOMMENDED**
  `$(document).ready(callbackFunction)`
  - a function passed to `$()` will be called only **after the DOM is fully loaded**
- put JS code before the </body> tag - **RECOMMENDED**
  - the JS code will load only after all other elements are loaded
  - enhances performance; as script tags at the top of the page block rendering

### ways of using `$`
||selector-style|HTML-style|Wrapper-style|Callback-style|
|-|-|-|-|-|
|argument type|string|string|`HTMLElement`|function|
|argument|CSS selector string|HTML code|Unwrapped `HTMLElement`|callback function|
|return|jQuery object|jQuery object|jQuery object|-|

## Storing data inside the DOM
- `$.prototype.data(dataKey, dataVal)`
- vanilla HTML way:
  - `<tag_name data-dataName='{"key_name": value, ...}'>`
  - code sample
    ```html
    <li data-dog='{ "id": 234, "name": "Blixa", "genus": "Corgi Corgiorum" }'>
    </li>
    ```
  - `$.prototype.data(dataName)` retrieves the data value assigned to the `data-dataName` attribute

## ***Event Delegation***
- installing a single event handler on a parent to catch events on its children
- native `event.target` vs. `event.currentTarget`
  - `target is the element that directly receives the event`
  - `currentTarget is the element that has the event listener`
- jQuery event delegation
  ```js
  $('tag_1').on('eventname', 'tag_2', e => {})
  ```
  - `e.target` points to the element directly receiving the event
  - `e.currentTargget` now points to `tag_2`
  - `e.delegateTarget` is `tag_1`