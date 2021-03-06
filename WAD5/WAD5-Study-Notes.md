### state format
```js
{ entities: {
    slice1ItemNames: {
      1: { id:, ...},
      ...
    },
    slice1ItemNames: {
      ...
    }
  },
  ui: {
    loading: true/foals
  },
  errors: {
    login: ["error message"],
    tradeForm: ["error message"]
  },
  session: {
    currentUserID: ...
  }
}
```
---
## react-redux
- a **node package** with ***bindings*** simplifying the most common `React`-`Redux` interactions
  - ***binding*** - an API that provides glue code made to allow a language to use a library or operating system service not native to that language
  - allows threading of **Redux state** as **props** to React components
  - Allows threading of **functions** that can update Redux state to React components
- Setup
  - `npm install react-redux`
  - `import {Provider} from "react-redux"`

### Prop-threading
- [DEFINITION] **passing** an object **through props** all the way down to a deeply nested component, even if most **components on the chain do not need** the object 
  - code sample
    ```js
    // app.js
    import React from 'react

    const A() = ({store}) => (
      <...>{store.getState().xxx}</...>
    )

    const B() = ({store}) => (
      <...><A store={store} /></...>
    )

    export default const C() = ({store}) => (
      <...><B store={store} /></...>
    )

    // --------------------
    // entry.js
    import React from "react";
    import ReactDOM from "react-dom";
    import {createStore} from "redux"
    import reducer from "./reducer.js"
    import C from "./app.jsx"
    
    document.addEventListener("DOMContentLoaded", () => {
      const store = createStore(reducer);
      ReactDOM.render(<C store={store} />, ...)
    })
    ```
  - [CAVEAT] tedious and error-prone
    - [WORK-AROUND] using the `Provider` / `connect()` API provided by `react-redux`

### Provider
- takes in a **store** as a **prop**, and provides the store as the **context** to the **React component hierarchy**
- **pass the store to deeply nested components** **without explicit threading**
- used in the root component to **wrap the primary component** with the `Provider` component
  ```js
  // root.jsx
  const Root = ({store}) => {
    <Provider store={store}>
      <App />
    </Provider>
  }

  // entry.jsx
  document.addEventListener("DOMContentLoaded", () => {
    const store = createStore(reducer);
    ReactDOM.render(<Root store = {store} />, ...)
  })
  ```
- allows for components to access the store context using `connect()`

### Selectors
- **functions** that **extracts** and **format** information from the state
  - [example] taking a POJO and turning it into an array
  - argument: the **ENTIRE** application state
  - return: a subset of the **state** data that may be **formatted**
- location
  - `./frontend/reducers/selectors.js`
- use
  - invoke the selectors in the container's `mapStateToProps` argument
- purpose
  - make data in `state` more presentable and workable in React components 

### `connect()`
- connects the **given component** to a **specific slice of store** (specific slices of state/actions to dispatch)
- allows for passing slices of a store's state and actions to a React component as `props`, which serves as **the comopnent's API to the store**
  - **increases modularity**
- `connect(arg1, arg2)` is a ***high-order function***
  - takes two arguments (and some optional args) and **returns a function**
    ```js
    const createConnectedComponent = connect(
      mapStateToProps,
      mapDispatchToProps
    );

    const ConnectedComponent = createConnectComponent(TagName); //TagName is a React component
    ```
  - argument1 - mapping redux state to props
    - receives a function that returns a slice of props
    ```js
    const mapStateToProps = (state, ownProps) => ({
      propKey1: val1,
      propKey2: val2, 
      ...
    });
    ```
  - argument2 - mapping redux dispatch to props
    - receives a function that takes the store's `dispatch` method as an argument and returns a POJO of key-value pairs
      - the POJO keys are event handler names
      - the POJO values are action creator functions
    ```js
    const doSomething = arg => {type: ..., ...};

    const mapDispatchToProps = (dispatch) => ({
      handleSomething: ... => doSomething(...)
    });
    ```
### ***Containers***
- [DEFINITION] - the component generated by `connect()` that focuses on the connection with the Redux store rather than rendering
- ***presentational components*** vs. ***containers***
  - ***presentational components***
    - soly concerned with rendering jsx as product of props/state
    - may or may not have a corresponding container
  - ***containers***
    - subscribes the component to the redux store via `connect`
    - provides relevant slices of state to comopnent via `mapStateToProps`
    - Provides function that `dispatch` actions from presentational component via `mapDispatchToProps`

  ||presentational|container|
  |-|-|-|
  |purpose|how things look|how things work|
  |aware of Redux|no|yes|
  |reading data|from `props`|subscribe to Redux state|
  |changing data|invoke callbacks from `props`|dispatch Redux actions|
  |creation|by hand|`React-Redux` `connect`|
- file structure
  ```
  Components
  |-  item
  |---  item_containers.jsx
  |---  item.jsx
  ```

  ```js
  // item_containers.jsx (container)
  import Item from './item'
  connect(stateMapperFunc, dispatchMapperFunc)(Item);

  // item.jsx (presentational)
  const Item = ({/*...props received from the container*/}){
    return (<>...</>)
  }
  ```
