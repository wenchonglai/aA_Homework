# Ruby Metaprogramming

### `Object#send(:method_name)`
- Equivalent to `object_name.method_name`

### `ClassName::define_method`
- the method allows for dynamically defining new methods in a class
- call **at class definition**, **NOT** when a new instance is created
- `self` refers to the class object when being called

### `Object.method_missing(method_name, *args)`
- deals with situations in which a method **not defined** is called
- defaulted to throwing an exception, but can be overridden
- **[caveat] this method should be avoided; using macro is preferred**

### ***Type Introspection***
- `var.class` - shows the class name of the instance
- `var.is_a?(ClassName)`

***Class Instance Variable*** vs. ***Class Variable*** vs. ***Global Variable***
- ***Class Instance Variable***: an instance variable in a class method (`self` refers to `ClassName`)
    - **[caveat] CANNOT be inherited**
- ***Class Variable***:  can be inherited and shared between super-class and subclass
- ***Global Variable***: should be avoided as it is not OOP
    - exception: when an object will be useful throughout the entire program (i.e: `$stdin` and `$stdout`)

### Other Notes
`$stdout.isatty`
- checks if the $stdout is associated with the terminal environment
