###
Breakpoints
-----------

Unify responsive presentation and behavior by utilizing named breakpoints across
CSS and JavaScript.

Built on the technique shared by Jeremey Keith: http://adactio.com/journal/5429/

In brief, breakpoint names are stored in pseudo-elements, initiated by CSS.
JavaScript relies on these breakpoints named in CSS so media queries don't need
to be copy-pasted into JavaScript, and you definitely don't need to use the
at-present unreliable matchMedia().

@danott
http://github.com/danott
http://github.com/danott/breakpoints

MIT License.
###
class window.Breakpoints


  # ------------------
  # Instance variables
  # ------------------


  # "callbacks" stores all the callbacks registered using @add().
  # Once populated, takes the form of:
  #
  #   {
  #     mobile: {enter: [], exit: []},
  #     desktop: {enter: [], exit: []}
  #   }
  #
  # "enter" and "exit" are array of callback functions.
  callbacks = {}

  # "active" stores the name of the active breakpoint retrieved from the DOM.
  active = null 



  # --------------
  # Public methods
  # --------------


  # Public: the active breakpoint.
  #
  # Without an arugment returns a String of the active breakpoint.
  #
  # With an argument returns a Boolean of if the active breakpoint is equal to
  # the argument.
  #
  # Arguments:
  #
  #   name - breakpoint to test for. (Optional)
  #
  # Usage:
  #
  #   breakpoints = new Breakpoints
  #   breakpoints.active()
  #   => "mobile"
  #   breakpoints.active("mobile")
  #   => true
  #   breakpoints.active("desktop")
  #   => false
  #   
  # Returns a String or Boolean
  active: (name) ->
    if name?
      active == name 
    else
      active


  # Public: list all the available breakpoints.
  #
  # Usage:
  #
  #   breakpoints = new Breakpoints([{name: "mobile"}, {name: "desktop"}])
  #   breakpoints.available()
  #   => ["mobile", "desktop"]
  #
  # Returns an Array of Strings.
  available: ->
    key for own key, value of callbacks
  

  # Public: create a new instance of Breakpoints.
  #
  # Does the work of adding any of the BreakpointDefinitions passed in the
  # first argument, and sets up event listeners on appropriate window events.
  #
  # Arguments:
  #
  #   breakpointDefinitions - object (or array of objects) of the form of
  #                           BreakpointDefinition.  
  #   addEventListeners     - boolean that does what it says. Default: true.
  #
  # Usage:
  #
  #   breakpoints = new Breakpoints
  #   breakpoints = new Breakpoints({name: "mobile"})
  #   breakpoints = new Breakpoints([{name: "mobile"}, {name: "desktop"}])
  #   breakpoints = new Breakpoints(null, false)
  #
  # Returns a String of the active breakpoint.
  constructor: (breakpointDefinitions, addEventListeners = true) ->
    if addEventListeners
      window.addEventListener "resize", => @update()
      window.addEventListener "orientationchange", => @update()
    @add(breakpointDefinitions) if breakpointDefinitions?
    @update()



  # Public: add enter/exit callbacks to a named breakpoint.
  #
  # Arguments:
  #
  #   breakpointDefinitions - object (or array of objects) of the form of
  #       BreakpointDefinition.  
  #
  # Usage:
  #
  #   breakpoints = new Breakpoints
  #   breakpoints.add({name: "mobile", enter: enterFunc, exit: exitFunc})
  #   breakpoints.add([{name: "mobile", enter: enterFunc},
  #       {name: "desktop", exit: exitFunc}])
  #
  # Returns Boolean or Array of Booleans.
  add: (breakpointDefinitions) ->
    for breakpointDefinition in ensureArray(breakpointDefinitions)
      if validBreakpointDefinition(breakpointDefinition)
        addCallback(breakpointDefinition.name, "enter", breakpointDefinition.enter)
        addCallback(breakpointDefinition.name, "exit", breakpointDefinition.exit)
        true
      else
        false


  # Public: update the instance by looking at the DOM, and run any callbacks
  # that correspond with DOM changes.
  #
  # Arguments:
  #
  #   forceRunCallbacks - Defaults to false. If true, run the exit and enter
  #                       callbacks for the @active() breakpoint, even if
  #                       nothing has changed.
  #
  # Usage:
  #
  #   breakpoints.update()
  #   breakpoints.update(true)
  #
  # Returns a String of the active breakpoint.
  update: (forceRunCallbacks = false) ->
    previous = active
    active = activeFromDom()

    if (active != previous) || forceRunCallbacks  
      @add(name: active)
      runCallbacks(previous, "exit")
      runCallbacks(active, "enter")

    active


  # -----------------
  # "Private" methods
  # -----------------


  # Private: query the value of the named breakpoint as stored in the DOM.
  #
  # Working in tandem with CSS, this value is stored in the
  # body:after psuedo-element.
  #
  # Returns a String.
  activeFromDom = ->
    sanitizeDomString window.getComputedStyle(document.body,':after').getPropertyValue('content')


  # Private: ensure that a variable is in the form of an array.
  #
  # This allows us to accept arguments that are arbitrarily a single object,
  # or an array of objects.
  #
  # Arguments:
  #
  #   arrayish - could be literally anything.
  #
  # Returns an Array.
  ensureArray = (arrayish) ->
    [].concat arrayish


  # Private: add a callback for entering/exiting a breakpoint.
  #
  # Should not be referenced directly. Use the public method @add().
  #
  # Arguments:
  #
  #   breakpoint - the name of a breakpoint
  #   direction  - "enter" or "exit" for entering or exiting the breakpoint.
  #   callback   - a function to be executed when this breakpoint is entered or
  #                exited respectively.
  #
  # Returns nothing significant.
  addCallback = (breakpoint, direction, callback) ->
    callbacks[breakpoint] ?= {}
    callbacks[breakpoint][direction] ?= []
    callbacks[breakpoint][direction].push(callback) if callback?


  # Private: run callbacks.
  #
  # Arguments:
  #
  #   breakpoint - the name of a breakpoint.
  #   direction  - "enter" or "exit" for entering or exiting the breakpoint.
  #
  # Returns nothing significant.
  runCallbacks = (breakpoint, direction) ->
    if validBreakpointDefinition(new BreakpointDefinition(breakpoint))
      console.log "Breakpoints: #{direction} #{breakpoint}"
      callback.call() for callback in callbacks[breakpoint][direction]


  # Private: remove unwanted characters from a string retrieved from the DOM.
  #
  # Some browsers add these unwanted characters. Remove them.
  #
  # Arguments:
  #
  #   string - a String.
  #
  # Returns a string.
  sanitizeDomString = (stringish) ->
    stringish.replace(/["'\s]/g, "")


  # Private: breakpoints should conform to a certain set of requirements.
  #
  # This ensures these requirements are met.
  #
  # Arguments
  #
  #   breakpointDefinition - an object of the form BreakpointDefinition.
  #
  # Returns a Boolean.
  validBreakpointDefinition = (breakpointDefinition) ->
    breakpointDefinition.name? && breakpointDefinition.name.length > 0


# Public: BreakpointDefinition
#
# A simple object, mostly existant as documentation of what attributes
# are available for adding a breakpoint with Breakpoints.
#
# Attributes:
#
#   name  - The String name of a breakpoint, corresponding to breakpoints
#           defined in CSS.
#   enter - A callback executed when the breakpoint is matched.
#   exit  - A callback executed when the breakpoint is no longer matched.
#
# Usage:
#
# breakpoint = new BreakpointDefinition("mobile", enterFunc, exitFunc)
class window.BreakpointDefinition
  constructor: (@name, @enter, @exit) ->
