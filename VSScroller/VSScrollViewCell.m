//
//  VSScrollViewCell.m
//  VSScroller
//
//  Created by Vishal Singh Panwar on 01/06/13.
//  Copyright (c) 2013 Vishal Singh Panwar. All rights reserved.
//

#import "VSScrollViewCell.h"

@implementation VSScrollViewCell
@synthesize identifier;
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
    self = [[[NSBundle mainBundle]loadNibNamed:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])] owner:self options:nil]lastObject];
    if (self)
    {
        [self setIdentifier:identifierr];
    }
    return self;


}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"textLabel not included");
    
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
