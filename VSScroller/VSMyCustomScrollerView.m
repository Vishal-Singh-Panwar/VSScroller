//
//  VSMyCustomScrollerView.m
//  VSScroller
//
//  Created by Vishal Singh Panwar on 01/06/13.
//  Copyright (c) 2013 Vishal Singh Panwar. All rights reserved.
//

#import "VSMyCustomScrollerView.h"

@implementation VSMyCustomScrollerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithIdentifier:(NSString *)identifierr
{

  self =  [super initWithIdentifier:identifierr];
    if (self)
    {
        [self.myImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    

    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
