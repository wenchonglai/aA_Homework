# Babel
- [DEFINITION] a ***transpiler*** that converts the ES6 code to ES5 to ensure compatibility with all browsers and Node

### Configuration
- Install the appropriate NPM packages
  **`npm install @babel/core @babel/preset-env @babel/preset-react babel-loader`**
  - `@babel/core` - the **transpiling engine** itself
  - `@babel/preset-env` - **configurations** of how to interpret ES6
  - `@babel/preset-react` - **configurations** of how to interpret JSX
- Configure the **module** key of **`webpack.config.js`**
  ```js
  // allows for specifying several loaders with the webpack configuration
  module: {
    rules: [{
      test: [/\.jsx?$/],  // a regex that specifies file types to transpile
      exclude: [/(node_modules)/, /test\.js/], // avoid transpiling dependency files (as node_modules are large)
      loader: 'babel-loader', // sets Babel as the transpiler
      options: {
        presets: ['@babel/env', '@babel/react'] // specifies syntaxes to translate
      }
    }]
  }
  ```