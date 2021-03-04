# CSS Responsive Design

## ***Media Query***
- Write ***groups of*** CSS code that apply to different classes of devices based on screen widths, etc.
- media types
  - _https://css-tricks.com/snippets/css/all-stylesheet-media-types/_
  - `screen` - for computer screens
  - `print` - for printers
  - `tv` - for tv-type devices
- `min-width` - specifies the min width of a device

## Responsive Design Process
- determine a ***breakpoint*** (a critical with for substantial change of site layout)

## ***Mobile-First Design***
- design for the mobile devices first
- add support for larger devices using `min-width` media queries

## Viewport Meta Tag
- ```<meta name="viewport" content="width=device-width, initial-scale=1" />```
- tells the mobile browser not to automatically zoom out a desktop-sized interface
- required to responsive sites

---
# SCSS
## Features
- Variables
  - `$var_name: val`

- Nesting
  ```scss
  ul {
    ...;
    li {
      ...;
    }
  }
  /* equivalent to */
  ul {
    ...;
  }
  ul li {
    ...;
  }
  ```
  - `&` selector
    ```scss
    a {
      ...;
      &:hover {
        ...;
      }
    }
    /* equivalent to */
    a {
      ...;
    }
    a:hover {
      ...;
    }
    ```
  - namespace
    ```scss
    font: {
      family: val_1;
      size: val_2;
      weight: val_3;
    }
    /* equivalent to */
    font-family: val_1;
    font-size: val_2;
    font_weight: val_3;
    ```
- Import
  ```scss
  /* imports _partial_name.css */
  @import 'partial_name';
  ```
- Mix In
  - definition
    ```scss
    @mixin css-attr($var_name){
      css-attr-1: $var_name;
      css-attr-2: $var_name;
      ... 
    }
    ```
  - invocation
    ```scss
    @include css-attr(val)
    ```
- Extend
  - definition
    ```scss
    %styles-to-be-extended {
      css-attr-1: val1;
      css-attr-2: val2;
      ...
    }
    ```
  - use
    ```scss
    css-query-string {
      @extend %styles-to-be-extended
      css-attr-a: val_a
      css-attr-b: val_b;
      ...
    }
    ```
- Operators
  - `+`, `-`, `*`, `/`, `%`
