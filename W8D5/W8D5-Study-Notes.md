## Node Modules
- exporting
  ```js
  // val could be a class, array, or anything else
  module.exports = val
  ```
  - [CAVEAT] `require` only runs once for the same import file
  - [CAVEAT] all codes in the file being imported will run!
- importing
  ```js
  const ModuleName = require('./path/filename');
  ```
- loading multiple classes
  - store all module files to be included in one folder
  - create an index.js in the same folder
    ```js
    //index.js
    module.exports = {
      Module1: require('./module_1'),
      Module2: require('./module_2'),
      ...
    }
    ```
  - require the file path instead of the js files
    ```js
    const NameSpace = require('./path');
    ```

### readline
- ```js
  readline = require('readline');     // require

  reader = readline.createInterface({ // initialize
    input: process.stdin,
    output: process.stdout
  });

  reader.question(                    // use
    "question string",
    answer_callback_func(answer){
      ...
    }
  );

  // close the reader after use
  reader.close();                     // IMPORTANT!
  ```
- [CAVEAT] remember to call `reader.close()` after use!!!

---

## JS Async Function
- returns a `Promise` instance
- syntax
  ```js
  async function func_name(...args){
    // await must be associated with a promise
    await promise((res, rej) => {...});
    var_name = await ...;

    // runs after await gets response
    ...;

    return ...;
  }
  ```
---
# Event Loop
- Async functions schedule work to be done in the background
  - timers
  - AJAX requests
  - events
- Callbacks are invoked when:
  1.  action ready to occur and
  2.  stack is empty
 
---
# ES2016+ Features
- `Array.prototype.flat(level = 1)`
  ```js
  [1, [2, [3, 4]], [5, 6]].flat();
  // => [1, 2, [3, 4], 5, 6]

  [1, [2, [3, 4]], [5, 6]].flat(9999);
  // => [1, 2, 3, 4, 5, 6]
  ```
- `Array.prototype.flatMap(callback)`
  - flattens the return array from `Array.prototype.map`
    ```js
    [{a:1, b:2}, {a:3, b:4}].flatMap(obj => [obj.a, obj.b]);
    // => [1, 2, 3, 4];
    ```
