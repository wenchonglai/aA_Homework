# Javascript
### Data Types
- Primitives
  - `Boolean`, `Null`, Undefined, `Number`, `String`, `Symbols`, `BigInt`
  - [caveat]
    ```js
    // comparing the values of two string primitives
    "hello" == "hello" // true
    "hello" === "hello" // true

    // comparing two string objects
    new String("hello") == new String("hello") // false
    new String("hello") === new String("hello") // false
    ```
- Objects
  - different from Ruby objects
  - essentially big hashmaps
  - can have functions (aka. ***methods***) as values
  - can access object ***attributes*** with `[]` or `.` notations

---
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
  - `var` and `function` allow for hoisting and can be accessed before declaration
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
  - variables declared through`let`, `const`, and *global declaration* cannot be accessed before declaration even though they are hoisted
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
---
## Functions
- a type of Object
- First-class object in JS:
  - can be passed as arguments
  - can be returned from other functions
  - can be assigned to variables
- can be stored in data structures
- can have as many or as few arguments as wanted
- 3 types of Functions
  - ***Named function***
    `let foo = function(){}`
  - ***variable/anonymous functions***, aka. ***function expression***
    `function(){}`
  - ***Constructor function***
    - used to create new objects
    - similar to class definitions in Ruby
    - instance methods are added to the prototype of an object
- invoking a function
  - ***method style***
  - ***function style***
  - ***constructor style***
***callbacks***
- a function that is passed as an argument
- can be as simple as passing a function to `forEach`

***Closures***
A function which accesses variables that were neither passed in nor defined inside that function scope
- a function that captures free variables and 'closes' over them
- can be used to create "private state"

### this
- akin to Ruby's `self`
- [caveat] never implicit; cannot be omitted
- value of `this` is a function's ***context*** or ***receiver***
- in constructor functions
  - points to instance
- in arrow functions
  - `undefined`
  - accessing `this` will get the `this` from the outer functional scope
- in other functions
  - the `this` in the outer functional scope


