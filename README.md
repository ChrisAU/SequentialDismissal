# Sequential View Controller Presentation and Dismissal
Extension for sequential Presentation and Dismissal of View Controllers

Presentation will occur on top of stack, meaning you can call these methods from anywhere in the view controller hierarchy. Dismissal will start from top of stack and finish when it reaches the caller view controller.

Create some dummy view controllers to be used in below examples...
````
let a = dummyViewController()
let b = dummyViewController()
let c = dummyViewController()
let d = dummyViewController()
````

**presentOnTop**:

Presentation will wait for previous event to finish before starting a new one eliminating the errors caused by the 'present' method if a view controller is already being presented or dismissed.

*Example:*
````
presentOnTop(a)
presentOnTop(b)
presentOnTop(c)
presentOnTop(d, animated: true, completion: { })  // Showing Optional fields
````

**sequentialPresentation**:

Presentation will first wait until any view controllers that are currently being dismissed or presented have completed before then presenting the provided view controllers on top of the stack (meaning you can call this method from the Root View Controller even if it's already presenting something).

*Example:*
````
presentOnTop(a)
sequentialPresentation(of: [b])
sequentialPresentation(of: [c, d], animated: true) {
    // Complete
}
````

**sequentialDismissal**:

Now that we've presented some view controllers we should be able to dismiss one of them from anywhere in the stack without it throwing an error. That's where this method comes in. 

*Note:* This method must be called after presentation has occurred otherwise it won't find the view controller in the stack.

*Example:*
````
sequentialPresentation(of: [a, b, c, d]) {
    b.sequentialDismissal()  // Dismiss c, d
}
````
