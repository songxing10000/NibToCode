#import <Foundation/Foundation.h>

@interface ZHStroyBoardToFrameModel : NSObject
@property (nonatomic,copy)NSString *firstItem;
@property (nonatomic,copy)NSString *secondItem;
@property (nonatomic,copy)NSString *firstAttribute;
@property (nonatomic,copy)NSString *secondAttribute;
@property (nonatomic,copy)NSString *constant;
@property (nonatomic,copy)NSString *multiplier;
@property (nonatomic,assign)BOOL isChild;
- (NSString *)getValueWithItem:(NSString *)item viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM;
@end
