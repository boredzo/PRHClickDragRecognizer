#import <Cocoa/Cocoa.h>

@protocol PRHClickTarget, PRHDragTarget;

@interface PRHClickDragRecognizer : NSResponder

@property(weak) id <PRHClickTarget> clickTarget;
@property(weak) id <PRHDragTarget> dragTarget;

@property NSPoint dragStartPoint;

@end

@protocol PRHClickTarget <NSObject>

- (void) clickPerformed:(NSEvent *)event;

@end

@protocol PRHDragTarget <NSObject>

- (void) dragStarted:(NSEvent *)event;
- (void) dragEnded:(NSEvent *)event;

@optional
//Called whenever the user moves the mouse during a drag.
- (void) dragContinued:(NSEvent *)event;

@end
