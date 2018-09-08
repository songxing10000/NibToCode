#import "ZHStoryboardTextManager.h"

@interface ZHStoryboardTextManagerToMVC : ZHStoryboardTextManager
+ (void)addDelegateFunctionToText:(NSMutableString *)text withTableViews:(NSDictionary *)tableViewsDic isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews;
+ (void)addDelegateFunctionToText:(NSMutableString *)text withCollectionViews:(NSDictionary *)collectionViewsDic isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews;
@end