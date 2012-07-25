#import "GridView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation GridView

@synthesize scrollView = _scrollView;
@synthesize buttons = _buttons;
@synthesize items = _items;
@synthesize pageControl = _pageControl;
@synthesize imageButtonTarget = _imageButtonTarget;
@synthesize imageButtonTargetAction;
@synthesize loadedPages;

static int itemsPerRow = 3;
static int itemsPerPage = 36;
static int totalWidth = 1024;  // 768 for portrait

- (id)initWithFrame:(CGRect)aRect {
  // horizontal layout only 
  CGRect frame = CGRectMake(0,0,1024,aRect.size.height);
  self = [super initWithFrame:frame];
  self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
  _scrollView.pagingEnabled = YES;
  _scrollView.scrollsToTop = YES;
  _scrollView.delegate = self;
  [self addSubview:_scrollView];

  float pageControlWidth = 100;
  int x = 512 - (pageControlWidth / 2);
  CGRect pageControlFrame = CGRectMake(x, 650, pageControlWidth, 50);
  self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
  [_pageControl addTarget:self action:@selector(paging:) forControlEvents:UIControlEventValueChanged];
  [self addSubview:_pageControl];
  self.buttons = [NSMutableArray array];
  return self;
}

// items are an NSArray of NSDictionary containing NSString and/or UIImage
- (void)displayItems:(NSArray *)items target:(id)target action:(SEL)action {
  self.loadedPages = [NSMutableSet set];
  self.imageButtonTarget = target;
  self.imageButtonTargetAction = action;
  if (self.buttons) {
    NSLog(@"removing buttons");
    for (UIButton *i in self.buttons) {
      [i removeFromSuperview];
    }
    self.buttons = [NSMutableArray array];
  }
  self.items = items;

  for (int i = 0; i < MIN([items count], (itemsPerPage * 2)); i++) 
  {
    NSDictionary *item = [items objectAtIndex:i];
    NSMutableDictionary *mutableItem = [[NSMutableDictionary alloc] initWithDictionary:item];
    [mutableItem setObject:[NSNumber numberWithInt:i] forKey:@"index"];
    [self addButton: mutableItem];

    if (i % itemsPerPage == 0) {
      [self.loadedPages addObject:[NSNumber numberWithInt:(i / itemsPerPage)]];
    }
  }
  _scrollView.contentSize = CGSizeMake(totalWidth * (([items count]/itemsPerPage) + 1), 768);
  [_scrollView setContentOffset:CGPointMake(0,0) animated:NO];
  _pageControl.numberOfPages = ([items count] / itemsPerPage) + 1;
  _pageControl.currentPage = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int xOffset = scrollView.contentOffset.x;
  int page = (xOffset/ 1024);
  int pageToLoad = page + 2; // to pages ahead
  if (![self.loadedPages member:[NSNumber numberWithInt:pageToLoad]]) {
    [self.loadedPages addObject:[NSNumber numberWithInt:pageToLoad]];

    int startIndex = MIN([self.items count], pageToLoad * itemsPerPage);
    int endIndex = MIN([self.items count], startIndex + itemsPerPage);
    for (int i = startIndex; i < endIndex; i++) 
    {
      NSDictionary *item = [self.items objectAtIndex:i];
      NSMutableDictionary *mutableItem = [[NSMutableDictionary alloc] initWithDictionary:item];
      [mutableItem setObject:[NSNumber numberWithInt:i] forKey:@"index"];
      [self addButton: mutableItem];
    }
  }
}

- (void)addButton:(NSDictionary *)item {

  int col, row, x, y;
  int page = 0;  
  int cellWidth = 250; 
  int cellHeight = 50;
  int columnPadding = 30;
  int leftOffset = 75;

  NSString *title = [((NSDictionary *)item) objectForKey:@"title"];
  NSUInteger i = [((NSNumber *)[item objectForKey:@"index"]) intValue];

  col = i % itemsPerRow;
  row = (i % itemsPerPage) / itemsPerRow;
  page = i / itemsPerPage;
  x = (totalWidth * page) + leftOffset + ((cellWidth + columnPadding) * col);
  y = 20 + (50 * row);

  if (title) {
    NSLog(@"adding button");
    NSLog(@"adding item at index %d %@ at col %d, x %d", i, [item objectForKey:@"title"], col, x);
    UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    titleButton.frame = CGRectMake(x, y + cellHeight, cellWidth, 30);
    titleButton.titleLabel.font = [UIFont systemFontOfSize: 10];
    titleButton.tag = i;
    [titleButton setTitle:title forState:UIControlStateNormal];
    [_scrollView addSubview:titleButton];
    [self.buttons addObject:titleButton];
  } 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat x = scrollView.contentOffset.x;
  CGFloat w = scrollView.bounds.size.width;
  self.pageControl.currentPage = x/w;
}

- (void)paging:(id)sender 
{
  NSInteger p = _pageControl.currentPage;
  CGFloat w = 1024;
  [_scrollView setContentOffset:CGPointMake(p * w, 0) animated:YES];
}

@end
