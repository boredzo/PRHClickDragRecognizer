# PRHClickDragRecognizer
## A gesture recognizer for clicks and drags in Mac apps

Ever wanted UIGestureRecognizer, from Cocoa Touch, in Cocoa?

This is not that, but it covers a couple of the Mac use cases.

This is an object that you can own and use from your view that takes from you the work of distinguishing clicks from drags.

Each click/drag recognizer has two properties: a click target, and a drag target. Each of these has a corresponding protocol: the click target can be told that a click was performed, and the drag target can be told that a drag started, continued (optional), and ended.

In your view class, you respond to `mouseDown:`, `mouseDragged:`, and `mouseUp:` by forwarding those messages to the recognizer. It then interprets the events and sends you the appropriate higher-level messages defined in the protocols.

If either property is unset, the recognizer will not attempt to recognize that gesture. In particular, leaving the drag target unset means that every mouseDown/mouseDragged is effectively ignored and every mouseUp is a click.

This class does not attempt to replicate the class hierarchy design of UI*GestureRecognizer. You use exactly one object (per view/other target/pair of targets) to recognize both clicks and drags.

### Usage
1. Add this repo as a submodule of your repository, or (if you use a more user-friendly VCS than Git) download a zipball and extract it into your project folder.
2. Add the two source files to your project, and the .m file to your target.
3. Add the Carbon framework to your project and your target. Yes, this class needs it. Blame Apple. It still works on 64-bit.
4. In your view class's module file, import PRHClickDragRecognizer.h.
5. In your view class, create and own a PRHClickDragRecognizer object. Set yourself as the click target and/or the drag target.
6. Conform to the PRHClickTarget and/or PRHDragTarget protocols (as appropriate) and implement the methods you care about.
