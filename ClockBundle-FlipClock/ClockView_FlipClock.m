//
//  ClockView_FlipClock.m
//  iClock
//
//  Created by Werner Freytag on 03.03.12.
//  Copyright (c) 2012 Pecora GmbH. All rights reserved.
//

#import "ClockView_FlipClock.h"
#import "NSColor+CGColor.h"
#import "RegexKitLite.h"

@implementation ClockView_FlipClock

- (NSString *)title {
	return NSLocalizedString(@"FlipClock", @"Title of the clock view");
}

- (void)drawRect:(NSRect)dirtyRect {
	
	NSBundle *bundle = [NSBundle bundleWithIdentifier:@"de.pecora.iClock-ClockBundle-FlipClock"];
	
	NSString *imageName;
	NSImage *image;
	
	CGContextRef context = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	
	CGContextScaleCTM( context, self.bounds.size.width/128.0, self.bounds.size.height/128.0);
	
	image = [bundle imageForResource:@"Background.png"];
	[image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
	[timeFormatter setDateStyle:NSDateFormatterNoStyle];
	[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
	
	NSString *dateString = [timeFormatter stringFromDate:[NSDate date]];
	
	NSArray *result = [dateString arrayOfCaptureComponentsMatchedByRegex:@"([0-9])?([0-9])[^0-9]+([0-9]+)([0-9]+)"];
	NSArray *strings = [result objectAtIndex:0];
	
	if ( [[strings objectAtIndex:1] length] > 0 ) {
		imageName = [[strings objectAtIndex:1] stringByAppendingString:@".png"];
		image = [bundle imageForResource:imageName];
		[image drawAtPoint:CGPointMake(17, 44) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

		imageName = [[strings objectAtIndex:2] stringByAppendingString:@".png"];
		image = [bundle imageForResource:imageName];
		[image drawAtPoint:CGPointMake(38, 44) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	}
	else {
		imageName = [[strings objectAtIndex:2] stringByAppendingString:@".png"];
		image = [bundle imageForResource:imageName];
		[image drawAtPoint:CGPointMake(29, 44) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	}
	
	imageName = [[strings objectAtIndex:3] stringByAppendingString:@".png"];
	image = [bundle imageForResource:imageName];
	[image drawAtPoint:CGPointMake(72, 44) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
	imageName = [[strings objectAtIndex:4] stringByAppendingString:@".png"];
	image = [bundle imageForResource:imageName];
	[image drawAtPoint:CGPointMake(92, 44) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

	image = [bundle imageForResource:@"Foreground.png"];
	[image drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
	
	CGContextRestoreGState(context);
}

@end
