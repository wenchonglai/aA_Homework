# W5D3 CSS Notes

## Display
- `block`
  - *The default display for `<div>`*
  - tries to be as wide as possible
  - content before and after box appears on separate line
  - can have other elements as child
  - the vertical margins of two neighborhing block elements **WILL COLLAPSE**
  - `margin: 0 auto` horizontally centering a block element
- `inline`
  - *The default display for `<span>`*
  - Allows other elements to sit to its left and right
  - cannot have width and height set
  - doesn't respect top/bottom margin/padding
- `inline-block`
  - Allows other elems to sit to its left and right
  - respects witdth/height, and margin/padding (including top/bottom)

- `flex`
  - goes on the containter to affect the layout of its children
  - main idea: give the container the ability to alter it's children's placement and order to best fill the available space
  - intended to be a more ***flexible*** way of managing the content position and size of a site

---

## Flex Basics
- Add `display: flex` to a parent element
- `flex-direction`: specify the main axis
  - either `row` or `column`
- main axis determines how `justify-content` and `align-items` work

---

## Float & Clear
- **[Caveat] float and clear are archaic style attributes; do NOT use if flex is feasible.**
- Useful for making print design layout like newspaper
- float: `left`, `right`, `none`
- clear: `left`, `right`, `none`, `both`
- The floated element is removed from the ***normal flow of page***
- other elements 'floats around it'

### Clearfix
- if a floating element is floating outside of its container, make sure the floated element stays inside its parent
  ```css
  .clearfix::after {
    content: "";
    clear: both;
    display: table; /*or block*/
  }
  ```

