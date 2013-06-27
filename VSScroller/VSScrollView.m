//
//  VSScrollView.m
//  VSScroller
//
//  Created by Vishal Singh Panwar on 01/06/13.
//  Copyright (c) 2013 Vishal Singh Panwar. All rights reserved.
//


#import "VSScrollView.h"
#import "VSScrollViewCell.h"
@interface VSScrollView()
{
    NSUInteger numberOfViews;
    UIScrollView *myScrollView;
    NSMutableDictionary *widthPositionDict;
    NSMutableArray *currentlyVissiblePositions;
    float currentPosition;
    BOOL lostCells;

}
@property (nonatomic,strong)id dequedVSScrollViewCell;
@property (nonatomic,assign)BOOL cellLostExpected;

-(void)constructViews;


@end


@implementation VSScrollView
@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initiateContainers];

    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
     myScrollView = [[UIScrollView alloc]initWithFrame:rect];
    [myScrollView setDelegate:self];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [myScrollView setShowsVerticalScrollIndicator:NO];
    [myScrollView setPagingEnabled:self.paginationEnabled];
    [self addSubview:myScrollView];
    [self initiateCalls];
    
    
}
-(void)awakeFromNib
{
    [self initiateContainers];
}

-(void)initiateContainers
{

    widthPositionDict = [[NSMutableDictionary alloc]init];
    currentlyVissiblePositions = [[NSMutableArray alloc]init];
    currentPosition = 0;

}


// calls the datasoruce methods to adjust the content size of its scrollview as well as responsible for presenting cells which will be vissible at the first launch.
-(void)initiateCalls
{
    numberOfViews = [self.dataSource numberOfViewInvsscrollview:self];
    if (numberOfViews>0)
    {
        CGFloat lastCoveredWidth = 0;
        for (int i = 0; i<numberOfViews; i++)
        {
            NSNumber *width = [NSNumber numberWithFloat:self.bounds.size.width];
            CGFloat cellSpacing = 0;
            CGFloat cellHeight = self.bounds.size.height;
            if ([self.dataSource respondsToSelector:@selector(vsscrollView:widthForViewAtPosition:)])
            {
                width = [NSNumber numberWithFloat:[self.dataSource vsscrollView:self widthForViewAtPosition:i]];
            }
            if ([self.dataSource respondsToSelector:@selector(cellSpacingAfterCellAtPosition:)])
            {
                cellSpacing=[self.dataSource cellSpacingAfterCellAtPosition:i];
            }
            
            if ([self.dataSource respondsToSelector:@selector(vsscrollView:heightForViewAtPosition:)])
            {
                cellHeight = [self.dataSource vsscrollView:self heightForViewAtPosition:i];
            }
            
            NSNumber *position = [NSNumber numberWithInt:i];
            NSValue *frameValue = [NSValue valueWithCGRect:CGRectMake(0+lastCoveredWidth, 0, [width floatValue], cellHeight)];
            lastCoveredWidth += [width floatValue]+cellSpacing;
            NSArray *infoArr = [NSArray arrayWithObjects:width,frameValue, nil];
            
            [widthPositionDict setObject:infoArr forKey:position];
        }
        
        [myScrollView setContentSize:CGSizeMake(lastCoveredWidth, 10)];
        [self constructViews];
    }

}

-(void)constructViews
{
    for (int i = 0; i<numberOfViews; i++)
    {
        NSValue *frameValueToSet = nil;
        if ([self needToAskDatasourceForVSScrollerViewForViewAtPosition:i andFrameValue:&frameValueToSet])
        {
            [currentlyVissiblePositions addObject:[NSNumber numberWithInt:i]];

            VSScrollViewCell *view =[self.dataSource vsscrollView:self viewAtPosition:i];
            [view setFrame:[frameValueToSet CGRectValue]];
            [view setTag:i+100];
             if (![myScrollView viewWithTag:view.tag])
            {

                 [myScrollView addSubview:view];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(vsscrollView:willDisplayCell:atPosition:)])
            {
                [self.delegate vsscrollView:self willDisplayCell:view atPosition:i];
            }
            NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
            [currentlyVissiblePositions sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];

        }
        else
        {
            [self adjustContentSizeForHeight];
            return;
        }
    }

}




-(VSScrollViewCell *)viewAtPosition:(int)i
{
   return (VSScrollViewCell *)[myScrollView viewWithTag:i+100];

}

-(BOOL)needToAskDatasourceForVSScrollerViewForViewAtPosition:(int )i andFrameValue:(NSValue **)frameValueToshow
{
    NSArray *info = [widthPositionDict objectForKey:[NSNumber numberWithInt:i]];
    NSValue *frameValue = [info objectAtIndex:1];
    CGRect frame = [self frameForPosition:i];
    if (CGRectIntersectsRect(frame, myScrollView.bounds))
    {
       *frameValueToshow =  frameValue;
        return YES;
        
    }
    return NO;

}


-(VSScrollViewCell *)dequeueReusableVSScrollviewCellsWithIdentifier:(NSString *)identifier
{
    VSScrollViewCell *dequedCell = (VSScrollViewCell *)self.dequedVSScrollViewCell;
    [self setDequedVSScrollViewCell:nil];
    if ([dequedCell.identifier isEqualToString:identifier])
    {
        if (dequedCell)
        {
            return dequedCell;

        }

    }
    
    for (VSScrollViewCell *views in [myScrollView subviews])
    {
        if ([views isKindOfClass:[VSScrollViewCell class]])
        {
            if ([views.identifier isEqualToString:identifier])
            {
                if (!CGRectIntersectsRect(views.frame, myScrollView.bounds))
                {
                    return views;
                }
            }
        }
      
    }
    
    return nil;
    

}


-(void)inqueueVSScrollviewCell:(BOOL)movingForward
{
    int nextPosition;
    int previousPosition;
    if ([currentlyVissiblePositions count]>0)
    {
        
    
    if (movingForward)
    {
        nextPosition = [[currentlyVissiblePositions lastObject]integerValue]+1;
    
        previousPosition = [[currentlyVissiblePositions objectAtIndex:0]integerValue];
    }
    else
    {
        nextPosition = [[currentlyVissiblePositions objectAtIndex:0]integerValue]-1;
        
       previousPosition = [[currentlyVissiblePositions lastObject]integerValue];
    
    }
    
    if (nextPosition<numberOfViews&&nextPosition>-1)
    {
        
        

        CGRect frame = [self frameForPosition:nextPosition];
        if (CGRectIntersectsRect(frame, myScrollView.bounds))
        {
            if (![currentlyVissiblePositions containsObject:[NSNumber numberWithInt:nextPosition]])
            {
                int insertIndex = movingForward? [currentlyVissiblePositions count]:0;
                [currentlyVissiblePositions insertObject:[NSNumber numberWithInt:nextPosition] atIndex:insertIndex];
                [self adjustContentSizeForHeight];

                VSScrollViewCell *view =[self.dataSource vsscrollView:self viewAtPosition:nextPosition];
                [view setFrame:frame];
                [view setTag:nextPosition+100];
                if (![myScrollView viewWithTag:view.tag])
                {
                    [myScrollView addSubview:view];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(vsscrollView:willDisplayCell:atPosition:)])
                {
                    [self.delegate vsscrollView:self willDisplayCell:view atPosition:nextPosition];
                }
                
            }
        }
        
    }
    CGRect framePreviousPosition =[self frameForPosition:previousPosition];
    if (!CGRectIntersectsRect(framePreviousPosition, myScrollView.bounds))
    {
        
        [currentlyVissiblePositions removeObject:[NSNumber numberWithInt:previousPosition]];
        [self adjustContentSizeForHeight];
        [self setDequedVSScrollViewCell:[myScrollView viewWithTag:previousPosition+100]];
    
    }
    }
    else
    {
        // when cell's width is small , during fast scrolling , scrollview looses cells to display. In this case lostCells is set to 'YES' . Need to work on this more. Called when [currentlyVissiblePositions count]<=0
        
        lostCells = YES;
    
    }
}



// is called when lostCells is set to YES
-(void)vissibleCells
{
    BOOL found = NO;
    for (int i = 0; i<numberOfViews; i++)
    {
        CGRect frame = [self frameForPosition:i];
        
        if (CGRectIntersectsRect(frame, myScrollView.bounds))
        {
            if (![currentlyVissiblePositions containsObject:[NSNumber numberWithInt:i]])
            {
                [currentlyVissiblePositions addObject:[NSNumber numberWithInt:i]];
                found = YES;
                
            }
           
        }
        else if(found==YES)
        {
            [self callForLostCells];
            return;
        
        }
        
    }
    if (found)
    {
        [self callForLostCells];

    }
    

}

-(void)callForLostCells
{
    for (int i = 0; i<[currentlyVissiblePositions count]; i++)
    {
         int position = [[currentlyVissiblePositions objectAtIndex:i]integerValue];
        VSScrollViewCell *view =[self.dataSource vsscrollView:self viewAtPosition:position];
        [view setFrame:[self frameForPosition:position]];
        [view setTag:position+100];
        if (![myScrollView viewWithTag:view.tag])
        {
            [myScrollView addSubview:view];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(vsscrollView:willDisplayCell:atPosition:)])
        {
            [self.delegate vsscrollView:self willDisplayCell:view atPosition:position];
        }

    }

}

-(CGRect)frameForPosition:(int)position
{
    NSArray *info = [widthPositionDict objectForKey:[NSNumber numberWithInt:position]];
    NSValue *frameVal = [info objectAtIndex:1];
    CGRect frame = [frameVal CGRectValue];
    return frame;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lostCells&&!self.cellLostExpected)
    {
        [self vissibleCells];
        lostCells = NO;
    }
    [self inqueueVSScrollviewCell:scrollView.bounds.origin.x>currentPosition];
    currentPosition = scrollView.bounds.origin.x;
   

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self removeAliveOutOfBoundsCells];
    if (self.delegate && [self.delegate respondsToSelector:@selector(positionsVissibleAfterScrolling:)])
    {
        [self.delegate positionsVissibleAfterScrolling:[NSArray arrayWithArray:currentlyVissiblePositions]];

    }

}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"called");
    if (!decelerate)
    {
        [self removeAliveOutOfBoundsCells];
    }

}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{



    if (lostCells)
    {
         [self vissibleCells];
         lostCells = NO;

    }
    [self setCellLostExpected:NO];
    [self adjustContentSizeForHeight];
    if (self.delegate && [self.delegate respondsToSelector:@selector(positionsVissibleAfterScrolling:)])
    {
        [self.delegate positionsVissibleAfterScrolling:[NSArray arrayWithArray:currentlyVissiblePositions]];
        
    }

}



-(void)adjustContentSizeForHeight
{
    if (self.allowVerticalScrollingForOutOfBoundsCell)
    {
        int maxHeightForVissibleViews = 10.0;
        for (int i = 0; i< [currentlyVissiblePositions count]; i++)
        {
        
            CGRect frame = [self frameForPosition:[[currentlyVissiblePositions objectAtIndex:i]integerValue]];
            if (frame.size.height>maxHeightForVissibleViews)
            {
                maxHeightForVissibleViews = frame.size.height;
            }
        }
        
        [UIView animateWithDuration:0.2 animations:^{
        
            [myScrollView setContentSize:CGSizeMake(myScrollView.contentSize.width, maxHeightForVissibleViews)];

        
        }];
    }

}


-(void)removeAliveOutOfBoundsCells
{
    int numberOfAliveCells = 0;
    UIView __weak *dequedView = nil;
    UIView __weak *otherView = nil;

    for (VSScrollViewCell *views in [myScrollView subviews])
    {
          if (!CGRectIntersectsRect(views.frame, myScrollView.bounds))
            {
                numberOfAliveCells++;
                if (![views isEqual:self.dequedVSScrollViewCell])
                {
                    if (numberOfViews>1)
                    {
                        [views removeFromSuperview];

                    }
                    else
                    {
                        otherView = views;
                    
                    }                    
                }
                else
                {
                
                    dequedView = views;
                }
               
            }
    }
    
    if (dequedView)
    {
        [otherView removeFromSuperview];
    }

}


-(NSArray *)postionsOfVissibleCells
{

  return [NSArray arrayWithArray:currentlyVissiblePositions];

}

-(void)reloadData
{
    [myScrollView scrollRectToVisible:myScrollView.frame animated:NO];
    [self removeAllCells];
    [widthPositionDict removeAllObjects];
    [currentlyVissiblePositions removeAllObjects];
     currentPosition = 0;
    [self initiateCalls];
  
}

-(void)scrollToPosition:(int)position
{
     self.cellLostExpected = YES;  // this is the case when cell lost is expected one would scroll from first view to 100th view...fast scrolling looses cell.
    [myScrollView scrollRectToVisible:[self frameForPosition:position] animated:YES];

}

-(void)removeAllCells
{
    for (UIView *views in [myScrollView subviews])
    {
        [views removeFromSuperview];
    }

}


@end
