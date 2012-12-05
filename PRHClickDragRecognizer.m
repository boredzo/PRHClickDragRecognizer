#import "PRHClickDragRecognizer.h"

//For HIMouseTrackingGetParameters and relevant types and constants
#include <Carbon/Carbon.h>

static bool PRHDistanceFromPointToPointExceedsDistances(NSPoint pointA, NSPoint pointB, CGSize maxDistances) {
	CGSize size = { fabs(pointA.x - pointB.x), fabs(pointA.y - pointB.y) };
	return size.width > maxDistances.width
		|| size.height > maxDistances.height;
}

@interface PRHClickDragRecognizer ()

- (bool) checkWhetherDragWasStartedByEvent:(NSEvent *)event;

@end

@implementation PRHClickDragRecognizer
{
	bool _inDrag;
	EventTime _clickTimeout;
	HISize _clickMaxDistance;
	NSPoint _mouseStartPoint;
	NSTimeInterval _mouseStartMoment;
}

- (id) init {
	if ((self = [super init])) {
		OSStatus err = HIMouseTrackingGetParameters(kMouseParamsDragInitiation, &_clickTimeout, &_clickMaxDistance);
		if (err != noErr) {
			_clickTimeout = 0.0;
			_clickMaxDistance = (HISize){ 4.0, 4.0 };
		}
	}

	return self;
}

- (void) mouseDown:(NSEvent *)theEvent {
	_inDrag = false;
	_mouseStartPoint = [theEvent locationInWindow];
	_mouseStartMoment = [theEvent timestamp];
	if (self.dragTarget == nil) [super mouseDown:theEvent];
}

- (void) mouseDragged:(NSEvent *)theEvent {
	bool handled = false;
	if (!_inDrag) {
		if (self.dragTarget != nil) {
			bool dragged = [self checkWhetherDragWasStartedByEvent:theEvent];

			if (dragged) {
				_inDrag = true;
				[self.dragTarget dragStarted:theEvent];
				handled = true;
			}
		}
	} else {
		if ([self.dragTarget respondsToSelector:@selector(dragContinued:)]) {
			[self.dragTarget dragContinued:theEvent];
			handled = true;
		}
	}

	if (!handled) [super mouseDragged:theEvent];
}

- (void) mouseUp:(NSEvent *)theEvent {
	if (_inDrag) {
		[self.dragTarget dragEnded:theEvent];
	} else if (self.clickTarget) {
		[self.clickTarget clickPerformed:theEvent];
	} else {
		[super mouseUp:theEvent];
	}
}

- (bool) checkWhetherDragWasStartedByEvent:(NSEvent *)event {
	NSPoint mouseCurrentPoint = [event locationInWindow];
	NSTimeInterval mouseCurrentMoment = [event timestamp];

	bool draggedFarEnough = PRHDistanceFromPointToPointExceedsDistances(_mouseStartPoint, mouseCurrentPoint, _clickMaxDistance);
	bool draggedLongEnough = ((mouseCurrentMoment - self->_mouseStartMoment) > _clickTimeout);
	bool dragged = (draggedFarEnough || draggedLongEnough);
	return dragged;
}

@end