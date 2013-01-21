breakpoints
===========

Unify responsive presentation and behavior by utilizing named breakpoints across CSS and JavaScript.

Usage
-----

```javascript
function enterMobile(){
  // ...
}

function exitMobile(){
  // ...
}

breakpoints = new Breakpoints({name: "mobile", enter: enterMobile, exit: exitMobile})
```
