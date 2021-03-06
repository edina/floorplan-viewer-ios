//
//  DemoAnnotationView.h
//  JCTiledViewDemo
//
//  Created by Jesse Collis
//  Copyright (c) 2012 JC Multimedia Design. All rights reserved.
//

#import "JCAnnotationView.h"
#import "CustomAnnotationView.h"
@interface DemoAnnotationView : JCAnnotationView


@property (strong, nonatomic) CustomAnnotationView *callout;

- (id)initWithFrame:(CGRect)frame annotation:(id<JCAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withView:(UIView *) view;

@end
