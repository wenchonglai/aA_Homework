# Redux Middleware
- a software that **intercepts a process**
- in redux, middleware refers to an ***`enhancer`***
  - passed to the store via `createStore(reducer, preloadedState, enhancer)` through the optional `enhancer` argument
    ```js
    import {createStore, applyMiddleware} from 'redux';
    import rootReducer from 'reducers';
    import logger from 'redux-logger'; // logger is a middleware

    const configureStore = (preloadedState = {}) => (
      createStore(
        rootReducer,
        preloadedState,
        applyMiddleware(/*middlewares go here*/)
      )
    );
    ```
  - intercepts the `action` when a `dispatch` is made
  - uses of a middleware
    - **resolve the action itself** (i.e. by making an AJAX request)
    - **generate a side effect** (i.e. logging debugging info)
    - **send another dispatch** (if the action triggers other actions)
    - **pass along the action** (if the middleware is not concerned with it)

### Middleware ***Signature***
- [DEFINITION] ***function signature*** - a set of inputs and output of a function
- middleware signature:
  `store => next => action => {/*side effects here*/ return next(action);};`

### redux-logger
- an npm package that consoles the previous and next state as well as actions with each dispatch
  - installation - `npm install redux-logger`
  - [CAVEAT] must the the last middleware

---

## Thunk Middleware
- A ***thunk*** is a **function** that **defers** work to be done later
- allows for writing ***thunk action creators*** that return a **function** instead of POJO
  - A ***thunk action*** is a **function**
  - if the action is a function:
    - invoke the function, passing in `dispatch` and `getState`
  - otherwise, pass the **action** along the **next middleware** or the **reducer** 
- have actions that are POJOs **OR** functions
- Benefits:
  - delay the dispatch of an action
  - conditionally dispatch actions
- `applyMiddleware()`
  ```js
  // store.js
  import {createStore, applyMiddleware} from 'redux';
  import thunk from 'redux-thunk'; // need to npm install
  ```

#### thunk middleware under the hood
  ```js
  const thunk = ({dispatch, getState}) => 
    next => 
      action => {
        if (typeof action === 'function')
          return action(dispatch, getState);
        return next(action);
      }
  ```

### Thunk action creator:
```js
// ./frontend/actions/noun_actions.js
import * as NounAPIUtil from '../utils/noun_utils'

// action creator; returns a POJO
export const receiveNouns = nouns => ({
  type: RECEIVE_NOUNS, 
  nouns
});

//thunk action creator; returns a function
export const fetchAllNouns = () => 
  (dispatch, getState) => (
    NounAPIUtil
      .fetchAllNouns()
      .then(nouns => dispatch(receiveNouns(nouns)))
);
```

### Review of React
- components (Class & Functional)
- local (Component) state
- Props

### Review of Redux
- Store
  - `getState` (function) -> read
  - `dispatch` (function) -> write
- `Provider` and `connect` -> Connected Components

## the Middleware concept
- intercepts actions (from React or Rails HTTP Response) entering into a store
  - ***Thunk*** determines if the action is a function or a POJ
    - if POJO -> send through
    - if function -> send $.ajax HTTP request to Rails
- Rails HTTP Response with a .then() promise in which `dispatch(/*new action with payload from $.ajax*/)` is sent to the middleware
---
## Rails Backend Setup
- create a Rails app using **`rails new ProjectName -g --database=postgresql`**
- sRails models
- Rails controllers
  - nest all rails controllers under an api namespace
    - purpose: to differentiate the front end and the back end
    - `rails controller api/nouns`
      - `class Api::NounsController < ApplicationController`
  - render json
    - **the back-end only provides data**
- Rails router
  ```rb
  # use defaults to avoid specifying datatype: json in the ajax response each time
  namespace :api, defaults: {format: :json} do
    resources :nouns, ...
  end

  # if the request is get '/', route to the static root page
  root to: 'static_pages#root'
  ```
- Rails root view
  ```html
  <!-- root.html.erb -->
  <div id='root'>React is broken</div>
  ```
## React Frontend Setup
- run `npm install` 
- create/update `webpack.config.js` to/at the root directory
  ```js
  output: {
    path: path.resolve(__dirname, 'app', 'assets', 'javascripts'),
    filename: './bundle.js'
  }
  ```
- create move the `frontend` folder to the root directory

## Connecting backend & frontend
- install jQuery 
  **`Gemfile`** - `gem jquery-rails`
  **`./app/assets/javascripts/application.js`** - `//= require jquery`
- API Utils via AJAX calls
  ```js
  export const fetchAllNouns = () => (
    $.ajax({
      method: 'GET',
      url: '/api/nouns'
    })
  );
  ```
- create folder `./frontend/utils`
  - create `noun_utils.js`
    ```js
    export const fetchAllNouns = () => (
      $.ajax({
        method: 'GET',
        url: '/api/nouns'
      })
    );

    export const createNoun = (noun) => (
      $.ajax({
        method: 'POST',
        url: '/api/nouns',
        data: {
          noun
        }
      })
    );
    ```
  - jsx
    - `import * as NounAPIUtil from './utils/noun_utils'`
- update Redux store