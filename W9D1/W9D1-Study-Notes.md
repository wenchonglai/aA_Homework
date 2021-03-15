## JS ***Prototypical Inheritance***
- JS implements inheritance through ***prototype chain***.
- When calling a property on an object, the JS interpreter:
  1.  looks for the property in the object itself
  2.  looks for the property in the object's prototype
      - at `object.__proto__`
      - `object.__proto__` == `object.constructor.prototype`
  3.  looks for the property in the constructor's prototype (which is a class)
      ...
  -   stops when the prototype is `Object.prototype`; `Object.prototype.__proto__ === null`
      - `Object` is the ***top level class*** in JS
- ways of implementing inheritance
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
      function Surrogate(){}

      Surrogate.prototype = ClassName.prototype();
      SubClassName.prototype = new Surrogate();
      SubClassName.prototype.constructor = SubClassName;
      ```
  5.  ES2015
      - `class SubClassName extends ClassName {}`
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
    