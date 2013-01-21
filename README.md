breakpoints
===========

Unify responsive presentation and behavior by utilizing named breakpoints across CSS and JavaScript.

Usage
-----

Step one, define named breakpoints in CSS. Named breakpoints take the form:

```css
@media screen and (max-width: 767px) {
  body:after {
    content: "mobile";
    display: none;
  }
}

@media screen and (min-width: 768px) and (max-width:979px) {
  body:after {
    content: "tablet";
    display: none;
  }
}

@media screen and (min-width:980px) {
  body:after {
    content: "desktop";
    display: none;
  }
}
```

Step two, reference the named breakpoints in your JavaScript, registering callbacks for when the breakpoint is entered or exited.


```javascript
// Define your callback methods
function enterMobile(){ /* Do something. */ }
function exitMobile(){ /* Do something. */ }
function enterTablet(){ /* Do something. */ }
function exitTablet(){ /* Do something. */ }
function enterDesktop(){ /* Do something. */ }
function exitDesktop(){ /* Do something. */ }

// Initialize Breakpoints
breakpoints = new Breakpoints({name: "mobile", enter: enterMobile, exit: exitMobile})

// You can even add callbacks after initialization
breakpoints.add([
  {name: "tablet", enter: enterTablet, exit: exitTablet},
  {name: "desktop", enter: enterDesktop, exit: exitDesktop}
])


// You can query the active breakpoint
breakpoints.active() // returns "mobile" (or "desktop" or "tablet")

// You can list all the available breakpoints
breakpoints.available() // returns ["mobile", "tablet", "desktop"]

// You can force breakpoints to update
breakpoints.update(true)
```

Customization
-------------

By default, Breakpoints adds event listeners and aggressively learns breakpoints on it's own. If you want to handle events on your own, you can pass `false` as a second argument when initializing Breakpoints.

```javascript
breakpoints = new Breakpoints(null, false) // Initialize breakpoints without setting up event listeners.
```

SASS
----

A sass mixin is provided to ease naming breakpoints. Using this mixin, you can define breakpoints as simply as:

```scss
@media screen and (max-width: 767px) {
  @include breakpoint("mobile");
}

@media screen and (min-width: 768px) and (max-width:979px) {
  @include breakpoint("tablet");
}

@media screen and (min-width:980px) {
  @include breakpoint("desktop");
}
```
