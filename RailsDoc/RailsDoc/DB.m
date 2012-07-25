#import "DB.h"

@implementation DB
sqlite3 *database;

- (id) init {
  if ((self = [super init])) {
    [self initializeDatabase];
  }
  return self;
}

- (void) initializeDatabase {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"rails" ofType:@"db"];
  if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
    NSLog(@"Opening database");
  } else {
    sqlite3_close(database);
    NSAssert1(0, @"Failed to open database: '%s'.", sqlite3_errmsg(database));
  }
}

- (void) closeDatabase {
  if (sqlite3_close(database) != SQLITE_OK) {
    NSAssert1(0, @"Error: failed to close database: '%s'", sqlite3_errmsg(database));
  }
}

- (void) printMethods {
  const char *sql = "select item_id, title, description from pages where parent_item_id is null and description is not null";
  sqlite3_stmt *statement;
  int sqlResult = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
  if (sqlResult == SQLITE_OK) {
    while (sqlite3_step(statement) == SQLITE_ROW) {
      char *itemId = (char *)sqlite3_column_text(statement, 0);
      char *title = (char *)sqlite3_column_text(statement, 1);
      char *description = (char *)sqlite3_column_text(statement, 2);
      NSLog(@"%s %s", itemId, title);
    }
    sqlite3_finalize(statement);
  } else {
    NSLog(@"Problem with database");
  }

}
@end
