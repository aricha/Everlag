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
		CHLoadLateClass(ENScalingFlipViewController);
		CHHook0(ENScalingFlipViewController, _postAnimationCleanup);
	}
}
