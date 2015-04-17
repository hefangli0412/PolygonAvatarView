//
//  PolygonView.m
//  Polygon
//
//  Created by Hefang Li on 4/15/15.
//  Copyright (c) 2015 hefang. All rights reserved.
//

#import "PolygonView.h"
#import <SAMCache/SAMCache.h>

#define DEFAULT_LINE_WIDTH 5
#define DEFAULT_SIDES_NUMBER 6

@interface PolygonView () <NSURLSessionDelegate>
// To manipulate those properties directly, put them in PolygonView.h
@property (strong, nonatomic) UIImage *avatarImage;
@property (assign, nonatomic) float lineWidth;
@property (assign, nonatomic) int numberOfSides;
@property (strong, nonatomic) UIColor *lineColor;
@end

@implementation PolygonView 

#pragma mark - Initializers

// Designated initializer
- (id)initWithFrame:(CGRect)frame imageNamed:(NSString *)imageName numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfSides = numberOfSides;
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        _avatarImage = [UIImage imageNamed:imageName];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame imageURL:(NSString *)urlString numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfSides = numberOfSides;
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        [self loadAvatarImage:urlString];
    }
    return self;
}

// Configure the view loaded from an Interface Builder nib file
- (void)configureWithImageNamed:(NSString *)imageName numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor
{
    _numberOfSides = numberOfSides;
    _lineWidth = lineWidth;
    _lineColor = lineColor;
    _avatarImage = [UIImage imageNamed:imageName];
}

- (void)configureWithImageURL:(NSString *)urlString numberOfSides:(int)numberOfSides lineWidth:(float)lineWidth lineColor:(UIColor*)lineColor
{
    _numberOfSides = numberOfSides;
    _lineWidth = lineWidth;
    _lineColor = lineColor;
    [self loadAvatarImage:urlString];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame imageURL:nil numberOfSides:DEFAULT_SIDES_NUMBER lineWidth:DEFAULT_LINE_WIDTH lineColor:[UIColor whiteColor]];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self configureWithImageURL:nil numberOfSides:DEFAULT_SIDES_NUMBER lineWidth:DEFAULT_LINE_WIDTH lineColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)loadAvatarImage:(NSString *)urlString
{
    _avatarImage = [UIImage imageNamed:@"avatar_placeholder"];
    
    if (urlString == nil) return;
    
    NSString *key = [urlString substringFromIndex:urlString.length-10];
    UIImage *image = [[SAMCache sharedCache] imageForKey:key];
    if (image) {
        _avatarImage = image;
    } else {
        // Background downloads
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            UIImage* image = [[UIImage alloc] initWithData:data];
            [[SAMCache sharedCache] setImage:image forKey:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                _avatarImage = image;
                [self setNeedsLayout];
            });
        }];
        [task resume];
    }
}

#pragma mark - Custom Layouts

- (void)layoutSubviews
{
    if (_numberOfSides == 0 || _lineColor == nil || _avatarImage == nil) { // not defined
        return;
    }
    
    CGFloat width = self.bounds.size.width;
    CGPoint outerCenter = CGPointMake(0.5 * width, 0.5 * width);
    CGPoint innerCenter = CGPointMake(0.5 * width - _lineWidth, 0.5 * width - _lineWidth);
    CGFloat outerRadius = 0.5 * width;
    CGFloat innerRadius = 0.5 * width - _lineWidth;
    
    // Define BezierPath.
    UIBezierPath *outerPath = [UIBezierPath bezierPath];
    
    NSArray *outerPoints = [self polygonPointArray:_numberOfSides center:outerCenter radius:outerRadius];
    [outerPath moveToPoint:[outerPoints[0] CGPointValue]];
    for (NSValue *val in outerPoints) {
        CGPoint p = [val CGPointValue];
        [outerPath addLineToPoint:p];
    }
    [outerPath closePath];
    
    UIBezierPath *innerPath = [UIBezierPath bezierPath];
    NSArray *innerPoints = [self polygonPointArray:_numberOfSides center:innerCenter radius:innerRadius];
    [innerPath moveToPoint:[innerPoints[0] CGPointValue]];
    for (NSValue *val in innerPoints) {
        CGPoint p = [val CGPointValue];
        [innerPath addLineToPoint:p];
    }
    [innerPath closePath];
    
    // Add avatar image.
    CGRect imageRect = CGRectMake(_lineWidth, _lineWidth, self.bounds.size.width-2*_lineWidth, self.bounds.size.width-2*_lineWidth);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = _avatarImage;
    [self addSubview:imageView];
    
    // Clip avatar image.
    CAShapeLayer * innerMaskLayer = [CAShapeLayer layer];
    innerMaskLayer.path = innerPath.CGPath;
    imageView.layer.mask = innerMaskLayer;
    
    // Clip to polygons.
    CAShapeLayer * outerMaskLayer = [CAShapeLayer layer];
    outerMaskLayer.path = outerPath.CGPath;
    self.layer.mask = outerMaskLayer;
    
    // Set line color.
    self.backgroundColor = _lineColor;
}

- (CGFloat)degree2radian:(CGFloat)a
{
    CGFloat b = M_PI * a/180;
    return b;
}

- (NSArray *)polygonPointArray:(int)sides center:(CGPoint)c radius:(CGFloat)r
{
    NSMutableArray *pointsArray = [[NSMutableArray alloc] init];
    
    CGFloat angle = [self degree2radian:(CGFloat)360/sides];
    
    for (int i = 0; i <= sides; i++) {
        CGFloat xpo = c.x - r * sin(angle * (CGFloat)i);
        CGFloat ypo = c.y - r * cos(angle * (CGFloat)i);
        [pointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(xpo, ypo)]];
    }
    
    return [pointsArray copy];
}

@end





