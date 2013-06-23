//
//  VSViewController.m
//  VSScroller
//
//  Created by Vishal Singh Panwar on 01/06/13.
//  Copyright (c) 2013 Vishal Singh Panwar. All rights reserved.
//

#import "VSViewController.h"
#import "VSScrollViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "VSMyCustomScrollerView.h"

@interface VSViewController ()
{
    NSMutableArray *dataArr;

}
@end

@implementation VSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableTypeScroll setDataSource:self];
    [self.tableTypeScroll setPaginationEnabled:NO];
    [self.tableTypeScroll setAllowVerticalScrollingForOutOfBoundsCell:YES];
    dataArr = [[NSMutableArray alloc]init];
    for (int i = 0;i<1000;i++)
    {
        [dataArr addObject:[NSString stringWithFormat:@"Batman is coming..  %i",i]];
                           
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)vsscrollView:(VSScrollView *)scrollView widthForViewAtPosition:(int)position
{
    return 200.0;

    if (position>10)
    {
        return 50;
    }
    return 200.0;
   // return scrollView.bounds.size.width;
}


-(CGFloat)cellSpacingAfterCellAtPosition:(int)position
{
    return 0;
    if (position>20)
    {
        return 100.0;

    }
    return 30.0;

}


-(CGFloat)vsscrollView:(VSScrollView *)scrollView heightForViewAtPosition:(int)position
{

    if (position>20&&position<40)
    {
        return 600.0;
        
    }
    return 60.0;


}

-(NSUInteger)numberOfViewInvsscrollview:(VSScrollView *)scrollview
{

    return [dataArr count];
}

-(VSScrollViewCell *)vsscrollView:(VSScrollView *)scrollView viewAtPosition:(int)position
{
    static NSString *identifier = @"vsscrollerViewIdentifier";
    
   // VSScrollerView *myView = [scrollView dequeueReusableViewWithIdentifier:identifier];
    VSMyCustomScrollerView *myView = (VSMyCustomScrollerView *)[scrollView dequeueReusableVSScrollviewCellsWithIdentifier:identifier];

    if (!myView)
    {
        myView = [[VSMyCustomScrollerView alloc]initWithIdentifier:identifier];

    }
    myView.layer.borderWidth = 2.0;
    [myView setBackgroundColor:[UIColor brownColor]];
    [myView.myImageView setImage:[UIImage imageNamed:@"batman.jpeg"]];
    [myView.myImageView setBackgroundColor:[UIColor purpleColor]];
    float alphaValue = (float)(position+1)/[dataArr count];
    [myView.myImageView setAlpha:alphaValue];
     myView.textLabel.text = [NSString stringWithFormat:@"  %@",[dataArr objectAtIndex:position]];
    [myView.textLabel setFont:[UIFont systemFontOfSize:10.0]];
    return myView;
}
- (IBAction)showCurrentlyVissiblePositions:(id)sender
{
    NSArray *arr = [self.tableTypeScroll postionsOfVissibleCells];
    NSString *positionStr = [arr componentsJoinedByString:@","];
    self.currentlyVissbleLbl.text = positionStr;
}

- (IBAction)reloadVSScroller:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag==102)
    {
        [dataArr addObject:[NSString stringWithFormat:@"Batman is coming..  %i",[dataArr count]]];

    }
    else
    {
        [dataArr removeLastObject];
    
    }
    [self.tableTypeScroll reloadData];
}

- (IBAction)goPressed:(id)sender
{
    int positionAsked = [self.positionTf.text integerValue];
    
    if ([self.positionTf isFirstResponder])
    {
        [self.positionTf resignFirstResponder];
    }
    
    if (positionAsked<[dataArr count])
    {
        [self.tableTypeScroll scrollToPosition:positionAsked];
    }
    else
    {
    
        self.positionTf.text = @"";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Batman is back" message:@"Invalid position" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([self.positionTf isFirstResponder])
    {
        [self.positionTf resignFirstResponder];
    }
    
}




- (void)viewDidUnload {
    [self setPositionTf:nil];
    [super viewDidUnload];
}
@end
