# Javascript
### 7 Falsey Values
- |Data Type|Falsey Values|
  |-|-|
  |undefined|`undefined`|
  |Object|`null`|
  |Boolean|`false`|
  |Number|`NaN`, `0`, `-0`|
  |String|`""`|
- objects other than `null` are always truthy
  - `[] == true`

### Type conversion while using `==`
- _https://developer.mozilla.org/en-US/docs/Web/JavaScript/Equality_comparisons_and_sameness#loose_equality_using_

### `var`, `let`, `const`, global, and `function`
- Comparison
  ||implicit|`var`|`let`|`const`|`function`|
  |-|-|-|-|-|-|
  |scope|global|function|curlies|curlies|the outer function scope|
  |redeclaration|yes|yes|yes(Chrome)/no|no|yes|
  |reassignment|yes|yes|yes|no|-|
  |*hoisting*|no|yes|no|no|yes|
- all variables declared in an outer scope is accessible from any of its inner scopes 
- [caveat] it will throw an error while accessing undefined variables
- [caveat] it will throw an error while redeclaring the same variable through `let` in the default JS environmen
  - exception: this behavior will not throw errors in Chrome
- [caveat] it will throw an error while declaring in an inner scope a variable through `var` if the variable is declared through `let/const`in the outer scope
  ```js
  { const a = 1;
    { var a = 1; //throws an error
    }
  }
  ```
- ***hoisting***
  - `var` and `function` allow for hoisting
    ```js
    console.log(a);   // undefined
    var a = 1;

    console.log(bar); // bar(){}
    function bar(){};

    console.log(c);   // undefined
    if (false) var c = 1;
    console.log(c);   // undefined

    console.log(foo); // undefined
    if (false) function foo(){};
    console.log(foo); // undefined
    ```
  - `let`, `const`, and *global declaration* do not allow for hoisting
    ```js
    console.log(d);   // error
    const d = 1;

    console.log(e);   // error
    const e = 1;

    console.log(f);   // error
    f = 1;

    let g = 1;
    { console.log(g); //  error
      let g = 2;
    }
    ```


