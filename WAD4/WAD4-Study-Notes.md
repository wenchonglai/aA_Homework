# Redux
## Application state
- all the info that is displayed and/or available to display on the frontend of an app
- when a change is made to an app resource (i.e. `CREATE`/`UPDATE`/`DESTROY`), the change is persisted to the database on the back-end and updated in the state on the front-end
- why use application state?
  - minimize API calls to back-end
  - allows for making changes on the webpage that do not need to be saved to database
  - rendering speed 

## Flux
- front-end application architecture
- **unidirectional** data flow
- **store** manages the **global state** of an app, and **can only be changed via diapatched actions**
- [NOTE] Flux is **NOT** specific to React

## Redux
- Most popular implementation of the Flux architecture
- Application state represented as one giant POJO
- Powerful because of its restrictions
- Developed by Dan Abramov in 2015 (who afterwards moved to the React team)

### When to Use Redux
- data changes over time
- cache data in memory  but it can change while cached
- data is relational, models include each other and depend on each other
- the same data is assembled from different sources and can be rendered in several places throughout the UI

### Trade-offs for Redux
- Pros
  - makes it easy to reason about complex data and UI changes
  - complements Reacts well
- Cons
  - boilerplate code
## Redux Principles
- **Single source of Truth**
- **State is read-only**
- Changes are made with **pure functions** (reducers)

## Mechanism
- Container
  - connect() sets props of Component
  - Component dispatch actions to the store
  - The RootReducer receives actions and sets new state
  - subscribers to changed slices to get new props

## File Structure
- Nest entire React app under `./frontend`
  - Setup entry file inside
  - `./frontend/components`
  - `./frontend/actions`
  - `./frontend/reducers`
  - `./frontend/store`

## ***store***
- [DEFINITION] an object that **manages the application state**, wrapped in a minimalist **API**
  - **central element** of Redux's architecture
  - holds the **global state** of an appliation
- With Redux we have **only one store** 
- responsible for
  - **updating** an app's **state** via its ***reducer***
  - **broadcasting the state** to an appliction's view layer via ***subscription***
  - **listening for *actions*** specifying how and when to change the global state

### Creating the store
- `createStore(reducer, [preloadedStte, [enhancer]]`
  - `reducer` - a **reducing function** that 
    - **receives** the app's **current state** and incoming **actions**
    - **determines** how to update the store's state
    - **returns the next state**
  - preLoadedState - an `object` storing **pre-existing states** before the store was created
  - enhancer - a `function` that **adds extra functionality** to the store
  - dynamically creating a store
    ```js
    import reducer from ...;

    const configureStore = (preloadedState = {}) => {
      return createStore(reducer, preloadedState)
    }
    ```
- code sample
  ```js
  //store.js
  import {createStore} from 'redux';
  import reducer from './reducer.js'

  const store = createStore(reducer);
  ```
### Store API
- `getState()` - see the current state of app
- `dispatch(action)` - dispatch an action to update state
---
## Reducers
- pure functions that update state based on the `action`'s type
- the entire state tree is a POJO
- each reducer corresponds to a key in the store's state
- takes `state` and `action`, returns the next state
  - the reducer must either return:
    - a **new array or object** with the updated state
    - or the same state object
- `RootReducer` combines multiple reducers into one using `combineReducers`
  - each reducer receives every dispatched action but only deals with its own slice of state
```js
const reducer = (state = [], action) => {
  // prevent mutating the original state
  object.freeze(state);

  // specifies the logic to implement based on action.type
  switch(action.type){
    // for each case, returns a new object representing the next state
    case ...: return [...state, ...];
    default: return state;
  }
}
```
- [CAVEAT] the **state is immutable in Redux**!
  - reducers in Redux are **pure functions**
  - use `Object.assign({}, origState)` to **shallow dup** the previous state
  - `use Object.freeze(origState)` to ensure the previous state cannot be mutated

### Combining Reducers
- ***reducer composition*** - **splitting** up the reducer into multiple reducers handling **separate, independent slices** of information  
  - purpose: avoid dealing with **deeply-nested reducers**
  - enhances modularity of code
- use a root reducer to combine the slices into one single piece:
  ```js
  import {combineReducers} from 'redux';

  const rootReducer = combineReducers({
    key1: key1Reducer,
    key2: key2Reducer,
    ...
  });
  ```

### Delegation
- since reducer returns a state, a delegator reducer can delegate actions to a delegatee reducer
- code sample
  ```js
  // returns a state
  const delegateeReducer = (state, action) => {...}

  const delegatorReducer = (state, action) => {
    Object.freeze(state);

    let nextState = Object.assign({}, state);

    switch xxx {
      case xxx: {
        nextState[action.xxx] = delegateeReducer(xxx, action);
        return nextState;
      } 
      ...
    }
  }
  ```
---
## Actions
- simple **POJOs (plain-old javascript objects)** with:
    - **a mandatory`type` key** indicating the action being performed
    - **optional payload keys** containing any new info
- gets sent using `store.dispatch()`
- Actions is **the only way** for view components to **trigger** changes to the store
- creation
  - use constants for all 'type' values
  ```js
  const doSomething = {
    type: 'DO_SOMETHING',
    key1: val1,
    ...
  }
  ```
  - **action creator** - functions that dynamically create action payloads (returns an action)
  ```js
  const doSomethingCreator = arg => ({
    type: "DO_SOMETHING",
    key1: ... // passes or processed arg
  })
  ```
- dispatch
  `store.dispatch(doSomething);` or
  `store.dispatch(doSomethingCreator(...));`


---
### Store API methods
- `getState()` - returns the store's current state
- `dispatch(action)` - passes an action into the store's `reducer` specifying information to be updated
  - when it is called, the store passes its current `state` along with the `action` to the `reducer`
- `subscribe(callback)` - **registers callbacks** to the store; the callback will triggered every time the store updates
  - **returns a function** that **unsubscribes the callback function** from the store when invoked
  ```js
  const callback = (...) => {...}
  const removeCallback = store.subscribe(callback);

  store.dispatch(...); // triggers callback

  removeCallback(); // callback will no longer be invoked
  ```

## Redux & React Components
- pass `store` via `props`
- subscribe to the component's `forceUpdate()`
  - the store triggers re-rendering every time an `action` is dispatched
  - [CAVEAT] this will trigger re-rendering all its children
    - [WORK-AROUND] use the `Provider / connect()` API

---
# Window API
## Browser Object Model (BOM)
- the ***API*** that allows **Javascript to communicate with the browser**
- `window`
  - a **global** ***POJO (Plain Old JS Object)***
    - allows for accessing functions and properties, as well as assigning new key-value pairs
  - available in all browsers
- using `window`
  - **the global context** when JS is run within a browser
  - _https://developer.mozilla.org/en-US/docs/Web/API/Window_