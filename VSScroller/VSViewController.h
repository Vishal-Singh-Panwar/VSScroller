//
//  VSViewController.h
//  VSScroller
//
//  Created by Vishal Singh Panwar on 01/06/13.
//  Copyright (c) 2013 Vishal Singh Panwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSScrollView.h"
@interface VSViewController : UIViewController<VSScrollerDatasource,VSScrollerDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *positionTf;
@property (weak, nonatomic) IBOutlet VSScrollView *tableTypeScroll;
@property (weak, nonatomic) IBOutlet UILabel *currentlyVissbleLbl;
- (IBAction)showCurrentlyVissiblePositions:(id)sender;
- (IBAction)reloadVSScroller:(id)sender;
- (IBAction)goPressed:(id)sender;
@end
