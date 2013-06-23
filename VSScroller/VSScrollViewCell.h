//
//  VSScrollViewCell.h
//  VSScroller
//
//  Created by Vishal Singh Panwar on 01/06/13.
//  Copyright (c) 2013 Vishal Singh Panwar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSScrollViewCell : UIView


@property(nonatomic,strong)NSString *identifier;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

-(id)initWithIdentifier:(NSString *)identifierr;
@end
