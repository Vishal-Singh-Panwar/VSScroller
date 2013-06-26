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
    [self.tableTypeScroll setDelegate:self];
   // [self.tableTypeScroll setPaginationEnabled:YES];
    dataArr = [[NSMutableArray alloc]init];
    for (int i = 0;i<100;i++)
    {
        [dataArr addObject:[NSString stringWithFormat:@"The Dark Knight is rising..  %i",i]];
                           
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
    if (position<20)
    {
        return 10.0;
        
    }
    else if (position<30)
    {
        return 50.0;
        
    }
    return 0.0;
}


-(CGFloat)vsscrollView:(VSScrollView *)scrollView heightForViewAtPosition:(int)position
{

    if (position>20&&position<40)
    {
        return 600.0;
        
    }
    return scrollView.bounds.size.height;


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
        [dataArr addObject:[NSString stringWithFormat:@"The Dark Knight is rising..  %i",[dataArr count]]];

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

-(void)vsscrollView:(VSScrollView *)scrollview willDisplayCell:(VSScrollViewCell *)cell atPosition:(int)position
{

    VSMyCustomScrollerView *myCustomCell = (VSMyCustomScrollerView *)cell;

    CGRect frame = myCustomCell.myImageView.frame;
    frame.origin.y =  frame.size.height-(frame.size.height/[dataArr count])*position;
        
    [myCustomCell.myImageView setFrame:frame];
    


}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([self.positionTf isFirstResponder])
    {
        [self.positionTf resignFirstResponder];
    }
    
}

-(void)positionsVissibleAfterScrolling:(NSArray *)positions
{
    NSLog(@"positions = %@",positions);

}


- (void)viewDidUnload
{
    [self setPositionTf:nil];
    [super viewDidUnload];
}
@end
