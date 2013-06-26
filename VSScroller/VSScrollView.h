//
//  VSScrollView.h
//  VSScroller
//
//  Created by Vishal Singh Panwar on 01/06/13.
//  Copyright (c) 2013 Vishal Singh Panwar. All rights reserved.
//

@class VSScrollView,VSScrollViewCell;
@protocol VSScrollerDatasource <NSObject>
-(VSScrollViewCell *)vsscrollView:(VSScrollView *)scrollView viewAtPosition:(int)position;

-(NSUInteger)numberOfViewInvsscrollview:(VSScrollView *)scrollview;
@optional

-(CGFloat)vsscrollView:(VSScrollView *)scrollView widthForViewAtPosition:(int)position; // you can decide variable width for views at differnet position. By default width is width of VSScrollView.

-(CGFloat)cellSpacingAfterCellAtPosition:(int)position;   // you can decide cell spacing for each position by implementing this method, by default , spacing is '0'


-(CGFloat)vsscrollView:(VSScrollView *)scrollView heightForViewAtPosition:(int)position; // you can decide the height for cells at each position...by default, height will be height of VSScrollview.


@end


@protocol VSScrollerDelegate <NSObject>

@optional
-(void)vsscrollView:(VSScrollView *)scrollview willDisplayCell:(VSScrollViewCell *)cell atPosition:(int)position; //is called whenever a cell is ready to be displayed.

-(void)positionsVissibleAfterScrolling:(NSArray *)positions; //gets called when scrollview ends decelerating and gives an array of currently vissible positions.


@end
typedef enum AnimationType
{
   kAnimationTypeAutomatic

}AnimationType;
#import <UIKit/UIKit.h>

@interface VSScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic,weak)id<VSScrollerDatasource>dataSource;
@property(nonatomic,weak)id<VSScrollerDelegate>delegate;

@property(nonatomic,assign)BOOL paginationEnabled;
@property(nonatomic,assign)BOOL allowVerticalScrollingForOutOfBoundsCell;  // tells whether VSScrollview should scroll vertically when some cell's height is greater thans VSSCrollview's height.


-(VSScrollViewCell *)dequeueReusableVSScrollviewCellsWithIdentifier:(NSString *)identifier;

-(NSArray *)postionsOfVissibleCells;

-(void)reloadData;

-(void)scrollToPosition:(int)position;


@end
