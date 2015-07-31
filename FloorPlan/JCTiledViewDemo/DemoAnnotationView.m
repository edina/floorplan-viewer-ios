//
//  DemoAnnotationView.m
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//

#import "DemoAnnotationView.h"

@implementation DemoAnnotationView

- (id)initWithFrame:(CGRect)frame annotation:(id<JCAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withView:(UIView *) view
{
  if ((self = [super initWithFrame:frame annotation:annotation reuseIdentifier:reuseIdentifier]))
  {
    self.callout = view;
    [self addSubview:view];
  }
  return self;
}


- (CGSize)sizeThatFits:(CGSize)size
{
  return CGSizeMake(MAX(_callout.frame.size.width,30.f), MAX(_callout.frame.size.height,30.f));
}


- (void)layoutSubviews
{
  [_callout sizeToFit];
  _callout.frame  = CGRectMake(0.f,0.f,CGRectGetWidth(_callout.frame), CGRectGetHeight(_callout.frame));
}

@end
