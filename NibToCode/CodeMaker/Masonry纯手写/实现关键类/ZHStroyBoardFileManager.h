#import <Foundation/Foundation.h>

/**这个类用于创建文件*/

@interface ZHStroyBoardFileManager : NSObject
+ (NSMutableDictionary *)defalutFileDicM;
+ (NSMutableDictionary *)defalutContextDicM;
+ (NSString *)getCurDateString;
+ (NSString *)getMainDirectory;
+ (void)creatFileDirectory;
+ (void)done;
+ (void)creat_MVC_WithViewControllerName:(NSString *)ViewController;
+ (void)creat_V_WithViewName_XIB:(NSString *)View;

+ (NSMutableString *)get_H_ContextByIdentity:(NSString *)identity;

+ (NSMutableString *)get_M_ContextByIdentity:(NSString *)identity;

+ (void)creat_m_h_file:(NSString *)fileName isModel:(BOOL)isModel isView:(BOOL)isView isController:(BOOL)isController isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creat_m_h_file_XIB:(NSString *)fileName forView:(NSString *)view;

+ (NSString *)getAdapterTableViewCellName:(NSString *)name;
+ (NSString *)getAdapterTableViewCellModelName:(NSString *)name;

+ (NSString *)getAdapterCollectionViewCellName:(NSString *)name;
+ (NSString *)getAdapterCollectionViewCellModelName:(NSString *)name;

+ (NSString *)getAdapterCollectionViewCellAndTableViewCellName:(NSString *)name;
+ (NSString *)getAdapterCollectionViewCellAndTableViewCellNameForPureHandProject:(NSString *)name;

+ (void)creatOriginalViewController_h:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creatOriginalViewController_m:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creatOriginalModel_h:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creatOriginalModel_m:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creatOriginalView_h:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creatOriginalView_m:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController;
+ (void)creatOriginalTableViewCell_h:(NSString *)name forViewController:(NSString *)viewController;
+ (void)creatOriginalTableViewCell_m:(NSString *)name forViewController:(NSString *)viewController;
+ (void)creatOriginalCollectionViewCell_h:(NSString *)name forViewController:(NSString *)viewController;
+ (void)creatOriginalCollectionViewCell_m:(NSString *)name forViewController:(NSString *)viewController;

+ (void)creatOriginalView_h:(NSString *)name forView:(NSString *)view;
+ (void)creatOriginalView_m:(NSString *)name forView:(NSString *)view;

#pragma mark 辅助函数
+ (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM;
+ (void)creatFileWithViewController:(NSString *)viewController name:(NSString *)name text:(NSString *)text isM:(BOOL)isM isModel:(BOOL)isModel isView:(BOOL)isView isController:(BOOL)isController;
+ (void)creatFileWithViewController_XIB:(NSString *)view name:(NSString *)name text:(NSString *)text isM:(BOOL)isM isModel:(BOOL)isModel isView:(BOOL)isView isController:(BOOL)isController;
@end