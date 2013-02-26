//
//  Everlag.mm
//  Everlag
//
//  Created by Andrew Richardson on 2013-02-25.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CaptainHook/CaptainHook.h"
#import <QuartzCore/QuartzCore.h>

CHDeclareClass(UIColor)
CHDeclareClass(UIView)

@interface UIColor ()
@property (nonatomic, retain, getter = _patternImage, setter = _setPatternImage:) UIImage *patternImage;
@end

@interface UIView ()
@property (nonatomic, retain) UIImageView *backgroundImageView;
@end

CHPropertyRetainNonatomic(UIColor, UIImage *, _patternImage, _setPatternImage);

CHOptimizedMethod1(self, id, UIColor, initWithPatternImage, UIImage *, pattern)
{
	if ((self = CHSuper1(UIColor, initWithPatternImage, pattern))) {
		self.patternImage = [pattern resizableImageWithCapInsets:UIEdgeInsetsZero];
	}
	return self;
}

CHPropertyRetainNonatomic(UIView, UIImageView *, backgroundImageView, setBackgroundImageView);

CHOptimizedMethod1(self, void, UIView, setBackgroundColor, UIColor *, color)
{
	UIColor *colorToUse = color;
	UIImage *patternImage = color.patternImage;
	if (color && patternImage) {
		colorToUse = nil;
		UIImageView *patternImageView = [[[UIImageView alloc] initWithImage:patternImage] autorelease];
		patternImageView.frame = self.bounds;
		patternImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.backgroundImageView = patternImageView;
		[self addSubview:patternImageView];
		[self sendSubviewToBack:patternImageView];
	}
	CHSuper1(UIView, setBackgroundColor, colorToUse);
}

CHOptimizedMethod1(self, void, UIView, sendSubviewToBack, UIView *, view)
{
	CHSuper1(UIView, sendSubviewToBack, view);
	
	UIImageView *bgView = self.backgroundImageView;
	if (bgView && view && bgView != view) {
		[self sendSubviewToBack:bgView];
	}
}

#pragma mark - Evernote

CHDeclareClass(ENScalingFlipViewController)

CHOptimizedMethod0(self, void, ENScalingFlipViewController, _postAnimationCleanup) // currently where shadow is set
{
	CHSuper0(ENScalingFlipViewController, _postAnimationCleanup);
	
	UIView **shadowView = CHIvarRef(self, _shadowView, UIView *);
	if (shadowView) {
		[*shadowView layer].shadowPath = [UIBezierPath bezierPathWithRect:[*shadowView bounds]].CGPath;
	}
}

CHConstructor
{
	@autoreleasepool {
		// note: this stuff improves performance only marginally, so it's not needed right now
//		CHLoadClass(UIColor);
//		
//		CHHookProperty(UIColor, _patternImage, _setPatternImage);
//		CHHook1(UIColor, initWithPatternImage);
//		
//		CHLoadClass(UIView);
//		
//		CHHookProperty(UIView, backgroundImageView, setBackgroundImageView);
//		CHHook1(UIView, setBackgroundColor);
//		CHHook1(UIView, sendSubviewToBack);
		
		CHLoadLateClass(ENScalingFlipViewController);
		CHHook0(ENScalingFlipViewController, _postAnimationCleanup);
	}
}
