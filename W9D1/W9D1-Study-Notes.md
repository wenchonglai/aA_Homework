- the context of an unbound funciton depends on **how the function is called**
  |style|how to invoke|`this`|
  |-|-|-|
  |function|`func()`|window/global|
  |method|object.func()|object|
  |constructor|new func()|object being created|
  |call|func.call(context, ...args)|context|
  |apply|func.apply(context, args)|context|
  - callback are always invoked in function-style
    - the context with a callback will be set to the `window` or `global`
    - need to `bind` the context if `this` is used within the callback
## currying
- [DEFINITION] a functional programming techique
  - that translates the evaluation of a function that **takes multiple arguments** into evaluating **a sequence of functions**, each with **a single argument**
- example
  ```js
  function _add3Nums(n1, n2, n3){ return num1 + num2 + num3;}

  // curried version
  function add3Nums(n1){
    return function(n2){
      return function(n3){
        return n1 + n2 + n3;
      }
    }
  }
  ```
- currying is useful when the **arguments** used by a function are **not all available at the same time**
- ```js
  function continuousAdd(){
    const args = [];

    return function _curriedAdd(num){
      args.push(num);
      console.log(args.reduce(acc, el) => {
        return acc + el;
      });

      return _curriedAdd;
    }
  }
  ```

## JS ***Prototypical Inheritance***
- [DEFINITION] ***inheritance*** - one object gets **access** to the **properties and functions defined on another object**
- JS implements inheritance through ***prototype chain***.
  - ruby uses classical inheritane
- When calling a property on an object, the JS interpreter:
  1.  looks for the property in the object itself
  2.  looks for the property in the object's prototype
      - at `object.__proto__`
      - `object.__proto__` == `object.constructor.prototype`
  3.  looks for the property in the constructor's prototype (which is a class)
      ...
  -   stops when the prototype is `Object.prototype`; `Object.prototype.__proto__ === null`
      - `Object` is the ***top level class*** in JS
### ***Constructor*** and ***Prototype*** - two key players in JS inheritance
  - ***constructor*** is a function, **handles initialization logic** and **specifies properties for each instance**
  - ***prototype*** is an object that defines the **shared behavior and properties** for all instances of a class 
    - The `prototype` is a property on a constructor function; `__proto__` is a property on objects used to link an instance to its prototype
    ```js
    Cat.prototype === (new Cat()).__proto__ === {constructor: Cat}
    ```
    - every object is associated with a prototype object
      - the only exception: `Object.prototype.__proto__ == null`
        - because `Object` is at the top of the prototype chain
      - the prototype object can be accessed through `__proto__`
        - [CAVEAT] `Object.getPrototypeOf(obj)` **is preferred**
    - if an object does not have a property, JS looks at its prototype through `__proto__` and keeps looking up its prototype chain
### constructor functions
- special type of function meant to create an object
- made to be used with the `new` keyword
  - constructs a new object
  - assigns the `__proto__` of the new object to `Constructor.prototype`
  - makes `this` point to the newly created object
  - calls the constructor function in the context of that new object
  - automatically returns the newly created object

- accepts arguments to set the new object's properties
- paired with a `prototype` object via `prototype` property
(*functions are objects and can have properties as well*)
- conventionally written with capital letter camelcase

### ways of implementing inheritance
1.  **[CAVEAT] bad practice!**
    `SubClassName.prototype.__proto__ = ClassName.prototype`
    - Not supported across browsers
    - Leads to poor performance
2.  **[CAVEAT] bad practice!**
    `Object.setPrototypeOf`
    - Also leads to poor performance**
3.  Use `Object.create` - **Recommended**
    - returns an entirely new object with `__proto__` set to the argument passed to `object.create`
    ```js
    SubclassName.prototype = Object.create(ClassName.prototype)
    ```
4.  Surrogate (old)
    ```js
    function ClassName(){}
    function SubClassName(){}
    function Surrogate(){}  // empty function

    // because Surrogate is an empty function, Surrogate.prototype will not be modified by the constructor function
    Surrogate.prototype = ClassName.prototype;

    
    SubClassName.prototype = new Surrogate();

    // ensure the right constructor is called when instantiating
    SubClassName.prototype.constructor = SubClassName;
    ```
    - [CAVEAT] - `Child.prototype.__proto__ == Parent.prototype` will **slow down the code**
5.  ES2015
    - `class SubClassName extends ClassName {}`

### Super
- in ES5:
  ```js
  function SubClassName(...args){
    SuperClassName.call(this, ...args);
  }
  ```
- in ES6:
  ```js
  class SubClassName extends SuperClassName{
    constructor(...args){
      super(...args);
    }
  }
  ```
---
## Browser-side Javascript
- importing modules
  - **[CAVEAT] there is no require in the native browser-side js!**
  - [work-around]
    ```html
    <!-- html -->
    <script src="pathname/filename.js"></script>
    ```

### ***Environment***
- [DEFINITION] programs like browsers and Node.js, which **expose functonality** that can be accessed by JS scripts through **APIs**.
The ***environments*** also called Javascript 

- Javascript APIs can access the functionalities provided by the ***environment***:
  - `document.getElementById` - DOM manipulation (from browsers)
  - `require('fs')` - File IO (from Node)

### ES6 incompatility & solution
- polyfill
  - test for the existing of a newer feature
  - if it does not exist, provide an alternative version
  ```js
  // example of a polyfill
  if (!String.prototype.includes){
    String.prototype.includes = function(...){...}
  }
  ```
- transpiler - **RECOMMENDED**

### ***Module Bundlers***
- [DEFINITION] tools that **bundle** the source files into a **single file** ready to use in the html **with one script tag**
- uses ***Abstract Syntax Tree*** to make sure all libaries requiring each other are loaded in the right order
  - [DEFINITION] ***Abstract Syntax Tree (AST)*** - 
    - a tree representation of the syntactic of structure of a programming language
    - each node denotes a construct in the source code
    ![abstract syntax tree (AST)](https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Abstract_syntax_tree_for_Euclidean_algorithm.svg/800px-Abstract_syntax_tree_for_Euclidean_algorithm.svg.png)

### ***Webpack*** - a module bundler
- if all source files use `require` to declare dependencies and `module.exports` to set exports, module bundlers can be used
- installation
  - global
    - **`npm install -g webpack webpack-cli`**
  - local
    - cli
      - **`npm init -y`**
      - **`npm install webpack webpack-cli --save-dev`**
      - **`npm install --save lodash`**
        - bundle `lodash` dependency with `index.js` through local installation
    - project structure
      ```
      project-name
      |- package.json
      |- /dist
        |- index.html
      |- /src
        |- index.js
      ```
      - `/src` stores source code we write
      - `/dist` stores the distribution code that is minimized and optimized
    - `./package.json`
      ```json
      { "name": "webpack-demo",
        "version": "1.0.0",
        "description": "",
        "private": true,  // note this line
        "scripts": {  // note the two lines below
          "test": "echo \"Error: no test specified\" && exit 1",
          "build": "webpack"  // allows for running "npm run build" in lieu of "npx"
        },
        "keywords": [],
        "author": "",
        "license": "ISC",
        "devDependencies": {
          "webpack": "^5.4.0",
          "webpack-cli": "^4.2.0"
        },
        "dependencies": {
          "lodash": "^4.17.20"
        }
      }
      ```
    - `./src/index.js`
      ```js
      // explicitly requires the module to be present
      import _ from 'lodash';

      function component(){
        const el = document.createElement('div');

        el.innerHTML = _.join(['Hello', 'webpack'], ' ');

        return el
      }

      document.body.appendChild(component());
      ```
    - `./dist/index.html`
      ```html
      <head>
        <script src="https://unpkg.com/lodash@x.y.z"></script>
      </head>
      <body>
        <script src="main.js"></script>
      </body>
      ```
    - **`npx webpack`**
      - takes the script at **`src/index.js`** as the entry point
      - generates `dist/main.js` as the output
- use
  - |`webpack`|`app.js`|`-o`|`bundle.js`|`--mode=development`|
    |-|-|-|-|-|
    ||input||output|optimze for development|
- webpack supports `import` and `export`
  - webpack transpiles the code so older browsers can also run it
  - webpack also supports other module syntaxes
    ||ES6|CommonJS|Web Assembly|
    |-|-|-|-|
    |file extension|`.mjs`|`.cjs`||
    |alt. extension  |`.js`|`.js`|`.wasm`|
    |`package.json` setting for alt extension|`"type": "module"`|`"type": "commonjs"`|`"type": "module"`|
    |file extensions while importing|required|-|required|
    |syntax|`import`/`export`|`require`/`module.exports`|-|
    - `.mjs` / `.js` w/ `"type": "module"` in `package.json`
      - no CommonJS allowed; `require`, `module.exports`, `exports` cannot be used
      - requires file
  - [CAVEAT] webpack **does not alter** any code **other than** `import` and `export` statements
    - use a transpiler (such as Babel) other ES2015 features via webpack's ***loader system***
- configurations
  - `webpack.config.js`
    ```js
    const path = require('path');
    module.exports = {
      entry: './src/index.js',
      output: {
        filename: 'main.js',
        path: path.resolve(__dirname, 'dist')
      }
    }
    ```
  - **`npx webpack --config webpack.config.js`**
    - [note]: **`npx webpack`** picks `webpack.config.js` by default 
    