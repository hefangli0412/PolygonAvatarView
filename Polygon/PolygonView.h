//
//  PolygonView.h
//  Polygon
//
//  This is a subclass of UIView that renders an image with colored, n-sided border around it. The class should allow one to specify the color, thickness and number of sides of the frame/border (which should be a regular, simple, convex polygon).  Anything outside of the border should not be visible.
//
//  Created by Hefang Li on 4/15/15.
//  Copyright (c) 2015 hefang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolygonView : UIView

// Designated initializer
- (id)initWithFrame:(CGRect)frame imageNamed:(NSString *)imageName numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor;

- (id)initWithFrame:(CGRect)frame imageURL:(NSString *)urlString numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor;

// Configure the view loaded from an Interface Builder nib file
- (void)configureWithImageNamed:(NSString *)imageName numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor;

- (void)configureWithImageURL:(NSString *)urlString numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor;

@end
