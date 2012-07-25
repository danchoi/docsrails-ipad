/*
 *
 * Includes both a UIScrollView and UIPageControl
 *
 */

#import <UIKit/UIKit.h>

@interface GridView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) id imageButtonTarget;
@property ( nonatomic) SEL imageButtonTargetAction;
@property (strong, nonatomic) NSMutableSet *loadedPages;
- (void)displayItems:(NSArray *)items target:(id)target action:(SEL)action;
- (void)addButton:(NSDictionary *)item;
@end
