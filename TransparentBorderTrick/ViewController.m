//
//  ViewController.m
//  TransparentBorderTrick
//
//  Created by Andrew Pouliot on 2/27/12.
//  Copyright (c) 2012 Darknoon. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

static const CGSize contentSize = (CGSize){400, 300};


@interface ViewController ()

@end

@implementation ViewController {
	UIImageView *_imageView;
	UILabel *_sizeLabel;
}
@synthesize borderSize = _borderSize;
@synthesize showDebugBorder = _showDebugBorder;

- (UIImage *)boringLayerContentsWithBorder:(CGFloat)border;
{
	CGRect outerRect = (CGRect){{}, {contentSize.width + 2*border, contentSize.height + 2*border}};
	CGRect innerRect = CGRectInset(outerRect, border, border);

	UIGraphicsBeginImageContextWithOptions(outerRect.size , NO, 0.0f /* Use main screen scale */);
	
	if (_showDebugBorder) {
		[[UIColor redColor] setFill];
		CGContextFillRect(UIGraphicsGetCurrentContext(), outerRect);
	}
	
	[[UIColor whiteColor] setFill];
	CGContextFillRect(UIGraphicsGetCurrentContext(), innerRect);
	
	UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return output;
}

- (void)_addRotationAnimations;
{
	CABasicAnimation *rx = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
	rx.toValue = [NSNumber numberWithFloat:2 * M_PI];
	rx.repeatCount = FLT_MAX;
	rx.duration = 37.0;
	
	CABasicAnimation *ry = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	ry.toValue = [NSNumber numberWithFloat:2 * M_PI];
	ry.repeatCount = FLT_MAX;
	ry.duration = 43.0;
	
	[_imageView.layer addAnimation:rx forKey:@"rx"];
	[_imageView.layer addAnimation:ry forKey:@"ry"];
}

- (void)_update;
{
	UIImage *contents = [self boringLayerContentsWithBorder:_borderSize];
	_imageView.image = contents;
	_imageView.bounds = CGRectInset((CGRect){.size = contentSize}, -_borderSize, -_borderSize);
	_sizeLabel.text = [NSString stringWithFormat:@"%.0f pt", _borderSize];
}

- (void)loadView;
{
	UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
	v.backgroundColor = [UIColor colorWithWhite:0.1f alpha:1.0f];
	v.multipleTouchEnabled = YES;
	v.userInteractionEnabled = YES;
	
	UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchBorderSize:)];
	singleFingerTap.numberOfTouchesRequired = 1;
	[v addGestureRecognizer:singleFingerTap];
	
	UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDebugBorder:)];
	doubleFingerTap.numberOfTouchesRequired = 2;
	[v addGestureRecognizer:doubleFingerTap];
	
	_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[v addSubview:_imageView];
	
	_sizeLabel = [[UILabel alloc] initWithFrame:(CGRect){30, 30, 100, 50}];
	_sizeLabel.textColor = [UIColor whiteColor];
	_sizeLabel.font = [UIFont boldSystemFontOfSize:24];
	_sizeLabel.backgroundColor = [UIColor clearColor];
	[v addSubview:_sizeLabel];
	
	//Add a little perspective
	CATransform3D t = CATransform3DIdentity;
	t.m34 = -1.0f / 900.f;
	v.layer.sublayerTransform = t;
	
	[self _update];
	[self _addRotationAnimations];
	
	self.view = v;
}

- (void)viewWillLayoutSubviews;
{
	_imageView.center = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)};
}

- (void)setBorderSize:(float)borderSize;
{
	_borderSize = borderSize;
	[self _update];
}

- (void)setShowDebugBorder:(BOOL)showDebugBorder;
{
	_showDebugBorder = showDebugBorder;
	[self _update];
}

- (IBAction)switchBorderSize:(id)sender;
{
	self.borderSize = _borderSize > 5 ? 0 : _borderSize + 1;
}

- (IBAction)toggleDebugBorder:(id)sender;
{
	self.showDebugBorder = !self.showDebugBorder;
}


@end
