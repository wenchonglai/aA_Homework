# DOM
- The `Document` is any webpage loaded in the browser, Entry point to the DOM
- A ref to the `Document` object exists as a property on the `Window` (i.e. `window.document`)
- DOM (Document Object Model) - A web API available for HTML, SVG, and XML documents
  - allows for programs to change the document structure, style, and content
  - uses nodes and objects to represent the tree structure of the document

### DOM Data Types
- `EventTarget`
  - `Node` - every obj located within the document is a node
    - `Document`
      - `HTMLDocument` - `document`
    - `Element` - refers to an element or a node of type element returned by a member of the DOM API
      - `HTMLElement` 
        - `HTMLHtmlElement` - `<html></html>`
        - `HTMLHeadElement` - `<head></head>`
        - `HTMLBodyElement` - `<body></body>`
- `HTMLCollection` - array-like collection of elements
- `NodeList` - array-like collection of nodes and canbe accessed through indexing

### DOM Manipulation Methods
- |method|return type|selector|
  |-|-|-|
  |`.getElementById(idString)` |`HTMLElement`|the given ID|
  |`.getElementsByClassName(classString)` |`HTMLCollection`|the given class|
  |`.getElementsByTagNames(tagName)`|`HTMLCollection`|the given tag|
  |`.querySelector(selector)` |`HTMLElement`|the given selector|
  |`.querySelectorAll(selector)`|`NodeList`|the given selector|
- `FormData`
  - gets the data of a form
  - `new FormData(formElement)`
  - `FormData.prototype.get(key)`
    - [caveat] - `formData[key]` will not work!

### DOM Styling methods
- Inline
  `element.style.property = "value"`
- Class
  `element.classList.add/remove/toggle`

### DOM Manipulation and JS
- DOM manipulation allows for **plain JS** to perform **CRUD operations** on the objects on the webpage
- Different browsers have different implementations of the DOM
  - can have slight differences between them
  - all use some type of DOM to allow access via JS

## Events and the DOM
- An event can be something the **browser** does or something a **user** does
  - `DOMContentLoaded`
  - `input`, `change`
  - `click`
  - `mouseover`/`mouseout`/`mouseenter`/`mouseleave`/`mousedown`
    - _https://www.w3schools.com/jquery/tryit.asp?filename=tryjquery_event_mouseenter_mouseover_
  - `keydown`/`keyup`/`keypress`(deprecated)
  - `load`
  - _developer.mozilla.org/en-US/docs/Web/Events_
- JS code can react to these events via event ***handlers*** or ***listeners***
- **3 ways** to register event handlers
  - `EventTarget.addEventListener()`
  - `<tag_name onclick="">`
  - `htmlElement.onclick = () => {}`
- bubbling
  - avoid adding event listener to specific nodes
  - insetad, add event listener to the common parent
  - after an event triggers on the deepest possible elements, it triggers on its parents in nesting order
  - the event listener analyzes bubbled events to find a match on child elements

## Local Storage
- storage of info on the browser
- key-value pairs
  - only stores strings
    - use `JSON.parse` to turn it into an object
- 5MB per browser
- `localStorage.setItem(key, val)`
- `localstorage.getItem(key)`
- `localstorage.clear()`

---
Web APIs
- APIs for either a web service
  -_developer.mozilla.org/en-US/docs/Web/API_

### History
- the `window.history` read-only property returns a ref to the `History` object
- provides an interface for the browser **session** history 
- **read-only**; no way to clear the session history or to disable the back/forward navigation from code

- methods
  - `window.history.back()`
  - `window.history.forward()`
  - `window.history.go(num)` - num can be positive and negative
  - - `window.history.length()`

## location
- `window.location.assign(url)`
- `window.location = url`
- `window.location.href = url`
- `window.document.URL` (READ ONLY)
- `window.location.replace(url)`

## Anchor
- `#` comes at the end of the url
- looks for ids with whatever string comes after the `#`
  - if it doesn't find any, nothing happens
  - if it does, takes the page and anchors it to that html element
- `window.location.hash` - reassign to change anchor via JS

- single-page app
- a web app that interacts with the user by dynamically rewriting the current page
- the appropriate resources are **dynamically loaded** and added to the page as necessary, usually **in response to user actions**