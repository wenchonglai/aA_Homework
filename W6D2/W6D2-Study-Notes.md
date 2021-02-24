# Ruby Metaprogramming

### What is ***metaprogramming***
- the essence of programming is defining behavior
- ***metaprogramming***
    - defines behavior that defines future behaviors
    - actively modifies the application behavior at runtime
    - often used to dynamically define a suit of similar methods based on undetermined future input to reduce duplicate code
    - examples
        - `attr_reader` / `attr_writer`
        - `belongs_to` / `has_many`
        - `validates`

### `self` in different scopes ***Class Instance Variable*** vs. ***Class Variable*** vs. ***Global Variable***
- ***Class Instance Variable***: an instance variable in a class method (`self` refers to `ClassName`)
    - **[caveat] CANNOT be inherited**
- ***Class Variable***:  can be inherited and shared between super-class and subclass
- ***Global Variable***: should be avoided as it is not OOP
    - exception: when an object will be useful throughout the entire program (i.e: `$stdin` and `$stdout`)
- **[caveat] self in the `define_method` block refers to the instance**

### breaking into the instance varaibles and private methods
- `Object#instance_variable_get` & `Object#instance_variable_set`
    - access the instance variables

- `Object#send(:method_name)`
    - Equivalent to `object_name.method_name`

### `define_method`
- the method allows for dynamically defining new methods in a class
- call **at class definition**, **NOT** when a new instance is created
- `self` refers to the class object when being called
- **[caveat] use `define_singleton_method` to define class methods**

### `Object.method_missing(method_name, *args)`
- deals with situations in which a method **not defined** is called
- defaulted to throwing an exception, but can be overridden
- **[caveat] this method should be avoided; using macro is preferred**

### ***Type Introspection***
- `var.class` - shows the class name of the instance
- `var.is_a?(ClassName)`


### Other Notes
`$stdout.isatty`
- checks if the $stdout is associated with the terminal environment
