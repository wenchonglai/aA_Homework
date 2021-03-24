# React
- [DEFINITION] a JS **front end library** for **building/managing UI components**
  - **the V in MVC**
  - When the **data** *that is represented by the UI* changes, React components **react** and **update** as needed
  - breaks up view to **modular components**
  - [CAVEAT] Reat is **NOT** a front-end MVC framework!
- abstracts away low-level DOM manipulation allowing developer to focus on how app should look and behave
- use: **manage all UI updates** when any changes is made, **instead of manually updating** elements in response to user input
- typically used with JSX - easily incorporate JS into HTML
- Virtual DOM

### How it works
- traditional JS apps: pieces of data changed must be identified and the DOM must be surgically updated
- React adapts the ***reconciliation*** process that:
  - once a component is **initially rendered** - React **generates and adds the markup** to the document
  - when the data is changed - React **renders again** using the **diff algorithm** to minimize changes that can be applied to the DOM
- ***reconciliation*** is fast (in milliseconds)
---
## React Concepts
### Single-Page App
- has only one **backend route** that renders HTML
- **asynchronous Ajax requests** allows for interation with database
- React updates the relevant portion of the page
  - React attempts to **update the minimal number of elements**
  - **improvement of performance** due to not entirely reload the page with every click

### Virtual DOM
- [CAVEAT] the DOM is **expensive** to manage and traverse
- the virtual DOM is a **simpler and faster abstraction** of the HTML DOM
- React is able to traverse and perform operations on the virtual DOM, and **only updates the real DOM when needed**

### Diffing Algorithm
- While rendering, React creates a **tree of React elements**
- When state or props update, React then renders a tree of **potentially different elements**
- the ***diffing algorithm*** generates the fewest number of operation needed to create, remove, replace, and update DOM nodes during rerendering
  - **O(n) time complexity**
- When diffing two trees:
  1.  React compares the two root elements
      - two elements of **different type**s, React will **destroy the old tree** and build a new tree *from scratch*
        - old Component instances will receive `componentWillUnMount`
          - states associated with the old tree are lost
          - any components below the root will also be unmounted and states destroyed
        - new Component instance will receive `UNSAFE_componentWillMount()` and then `componentDidMount()`
      - **two elements of the same type**
        - React will **keep the same underlying DOM node** and **update the changed attributes only**
        - `UNSAFE_componentWillReceiveProps()`, `UNSAFE_componentWillUpdate()`, and `componentDidUpdate()` will be called
        - the `render()` method is called and the diff algorithm recurses on the prev result and the new result
  2.  Rescurse on the children of the DOM node
      - if an element is added at the end, React will match all the existing elements and insert the new element
      - if an element is added at the beginning, React will mutate every children, which causes **inefficiency**
      - the **`key` attribute** is used to match children in the original tree with the children in the subsequent tree
---
## JSX
- [DEFINITION] - a ***JS syntax extension*** that **resembles HTML And XML**
- **produces React elements** which can be **DOM elements** or **another React components**
- [NOTE] **camelCase** naming convention
- **syntactic sugar** for `React.createElement`
- does **NOT** need to be used with React
- syntax
  - create
    ```jsx
    // React 
    const component = React.createElement({
      'tag_name',
      { attrName: "val" },
      React.createElement(...) // children
    });

    // JSX
    const component = (
      <tag_name attrName="val">
        <...></...> // children
      </tag_name>
    );
    ```
  - render
    ```js
    ReactDOM.render(tagName, document.body);
    ```
### Interpolation
- use `{}` to interpolate
- [CAVEAT] **only single expressions allowed** in an interpolation! 
  - **`;` is not allowed**
---
## React Component
- **JS function that return HTML** to be rendered onto a document
  - encapsulates pieces of UI containing both HTML and the means to manipulte it
- the **basic building blocks** of a React view-layer
  - A React app is a hierarchy, or tree, of React components
- typically written in JSX
- ***Single Responsibility Principle***
  - a React component should have only one responsibility
- **React Components should be **pure functions** (with respect to props)**
  1. with the same input, gives the same output
  2. 0 side effects
  3. does not mutate its input
---
## Using React with Node
- package dependency
  - **`npm install --save babel-core babel-loader babel-preset-react babel-preset-es2015 babel-preset-react`**
  - **`npm install --save react react-dom`**
- entry js file
  ```js
  import React from 'react'
  import ReactDOM from 'react-dom'
  import JSX_Class_Name from './JSX_CLASS_Name.jsx'
  ...
  ```
- index html file
  ```html
  <body>
    <scirpt src="distribution index.js here"></script>
  </body>
  ```

### Component Declaration
- Two different ways of declaring a React component:
  - ***Class component***: Inheriting from `React.Component`
  - must have a `render` function
  ```js
  class TagName extends React.Component{
    constructor(props){ super(props);
      ...
    }
    componentDidMount(){...}
    render(){
      return (<...>...</...>);
    }
  }
  ```
- ***Functional Component***
  - the function is the `render` function
  ```js
  const TagName = (props) => {
    let [stateName, setStateName] = useState(initState);
    
    useEffect(() => {...}, [...]);

    return (<...>...</...>);
  }
  ```
- render
  - React calls `render` for us
  - typically returns React Elements written using JSX
    - Can only return one root React element
  - can also return null
  - can also return booleans, arrays, strings, and numbers, but less common
---
## React ***Synthetic Events*** (aka. Event Handlers)
- [DEFINITION] - **React equivalent to `addEventListener`**
- [NOTE] React events have **camelCase** names
- [NOTE] **most event handlers will call `preventDefault()`**
- _https://reactjs.org/docs/events.html_
---
## Props & State
React components will re-render when their state or props change
### Props
- refer to properties of a component passed in **at the time of initialization** from a parent component or down to a child component
- [CAVEAT] do not change the Props!
### State
- refers to the **mutable** data that the ***component itself manages***
  - mostly used for **form** components to manage **controlled** inputs
- initializing state
  ```js
  class TagName extends React.Component{
    constructor(props){ super(props);
      this.state = {...}
    }
  }
  ```
- updating state
  - `this.setState()` - resets a component's state
    - triggers `render()` every time it is called
    - [NOTE] `setState()` **merges** the new value into `this.state` instead of creating a new state object
  - [CAVEAT] reassigning `this.state` using `this.state =` **will NOT trigger rerendering**
  - [CAVEAT] **`setState()` should NOT be called during `render`**
  - `this.state` may be upated **asynchronously**
  - takes an **optional callback** as a second argument

## ***Component Lifecycle Methods***
- [DEFINITION] functions that needs to be run at various points during a component's lifecycle
- Procedures
  1.  Mounting
      1.  `constructor()`
      2.  1st render
      3.  `componentDidMount()`
          - good place to call AJAX requests, set subscriptions like `setInterval`
  2.  Updating
      1.  new props / setState() / forceUpdate()
      2.  rerender
      3.  `componentDidUpdate()`
  3.  Unmounting
      1.  `componentWillUnmount()`
          - remove event listeners, clearInterval, clean up work, etc.
- common lifecycle methods
  - `componentDidMount`
  - `componentDidUpdate`
  - `componentWillUnmount`
  - `componentDidCatch` - catch errors
  - [CAVEAT] **the following methods should be avoided!**
    - `UNSAFE_componentWillUnmount`
    - `UNSAFE_componentWillUpdate`
    - `UNSAFE_componentWillReceiveProps`
---
## Debugging React

### Enzyme and Jest
- Enzyme: a testing library to compare React outputs
  - ***shallow rendering*** - the concept of unit testing a single component and not relying on the performance of its children
- Jest - a framework for running tests on React code
  - similar to RSpec and Jasmine

### React Developer Tools
- React is hard to debug
- React Developer Tools Chrome Extension
  _https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en-US_
---
# NPM - ***Node Package Manager***
- A ***package manager*** and ***software registry***
- Use to download various ***dependencies***
- `package.json` - a ***manifest file*** that lists all JS dependencies of a project 
  - `"main": "..."`: the entry file for an npm package
  - `"scripts": {}`
  - `"keywords"`: help people search the package
  - `"license"`: default: `"ISC"`
- use
  - `npm init --yes` - initialize a Node project
  - `npm install package_name` - install a package
    - `--no-save` - do not save the package to `package.json`
    - `--save-dev` or `-D` - only save as the app's development dependency
  - adding npm command line scripts 
    ```json
    "scripts": {
      "script_name": "command line command"
    }
    ```
    `npm run script_name` <==> `command line command`

# Yarn
- Yarn is similar to NPM

### Webpack
- `.gitignore`
  - **a file** that prevents the redundant files from being pushed to and pulled from the remote Git repo
  - sample
    ```
    # .gitignore

    node_modules/
    bundle.js
    bundle.js.map
    ```
  - _https://github.com/github/gitignore_
- `webpack.config.js` - configuration file that sets up webpack options. Do NOT reinvent the wheels every time!
  - [CAVEAT]: **use a good template** or write a really good template and reuse
  - need to **create by hand**
    ```js
    var path = require('path');

    module.exports = {
      entry: "...", // the entry point of the source files
      output: {
        // resolve the paths into an absolute path
        path: path.resolve(__dirname,  'folder_1_name', 'folder_2_name', ...),
        filename: "...", // output file name; typ. bundle.js
          extensions: ['.js', '.jsx', ..., '*']
        }
      }
      
      devtool: '...', // typically - "source-map"

      module: {
        rules: [{
          test: ...,
          exclude: ...,
          loader: ...,
          options: {
            presets: [...]
          }
        }]
      }

      resolve: {
        // allows for omitting file extensions while importing
        extensions: [...]
      }  
    }
    ```
  - for Rails projects, `bundle.js` should be located in **`app/assets/javascripts`**
  - ***source map*** - a tool that reveals the **line numbers** of the original code **when errors are raised**
  - [CAVEAT] the star matcher `'*'` must be included in the `extentions` in order to include files with an explicit extention
    - otherwise, `require(xxx.js)` will look for `xxx.js.js`

---


