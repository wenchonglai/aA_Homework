# Javascript
### `var`, `let`, `const`
- Comparison
  ||implicit|`var`|`let`|`const`|
  |-|-|-|-|-|
  |scope|global|function|bracket|bracket|
  |redeclaration w/i the same scope|yes|yes|no|no|
  |*hoisting*|no|yes|no|no|
- [caveat] it will throw an error if `var a =` is in an inner scope and `let/const a =` is in the outer scope
  ```js
  { const a = 1;
    { var a = 1; //throws an error
    }
  }
  ```


