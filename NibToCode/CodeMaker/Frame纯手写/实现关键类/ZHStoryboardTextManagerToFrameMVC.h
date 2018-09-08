#import "ZHStoryboardTextManagerToHandPureMVC.h"

@interface ZHStoryboardTextManagerToFrameMVC : ZHStoryboardTextManagerToHandPureMVC
/**创建约束代码*/
+ (NSString *)getCreatConstraintCodeWithIdStr:(NSString *)idStr WithViewName:(NSString *)viewName withConstraintDic:(NSDictionary *)constraintDic withSelfConstraintDic:(NSDictionary *)selfConstraintDic withOutletView:(NSDictionary *)outletView isCell:(BOOL)isCell withDoneArrM:(NSMutableArray *)doneArrM withCustomAndNameDic:(NSDictionary *)customAndNameDic addToFatherView:(NSString *)fatherView isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews withProperty:(ViewProperty *)property replaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM doneViewArrM:(NSMutableArray *)doneViewArrM viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM omissionsFrameViews:(NSMutableArray *)omissionsFrameViews;
+ (NSMutableString *)dealWithOmissionsFrameViewsWithCodeText:(NSMutableString *)codeText replaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM;
@end
