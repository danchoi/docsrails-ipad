#import "RootViewController.h"
#import "DB.h"
#import "GridView.h"

@implementation RootViewController
@synthesize gridView = _gridView;


- (void)loadView {
  [super loadView];

  DB *db = [[DB alloc] init];
  NSArray *methods = [db printMethods];
  NSLog(@"number of methods: %d", [methods count]);

  self.gridView = [[GridView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:self.gridView];
  [_gridView displayItems:methods target:self action:@selector(selectItem:)];
}

- (void)selectItem:(id)sender {
  NSLog(@"selected item");
}
@end
