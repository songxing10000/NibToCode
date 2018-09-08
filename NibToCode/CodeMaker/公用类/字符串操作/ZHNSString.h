

@interface ZHNSString : NSObject
#pragma mark 正则表达式验证
/**验证邮箱*/
+(BOOL)isValidateEmail:(NSString *)email;
/**验证密码*/
+(BOOL)isValidatePassword:(NSString *)pw;
/**验证昵称*/
+(BOOL)isValidateNickname:(NSString *)nickName;
/**验证手机号码*/
+(BOOL)isValidatePhoneNum:(NSString *)phone;
/**验证银行卡*/
+ (BOOL)isValidateBankCardNumber: (NSString *)bankCardNumber;
/**验证电话号码*/
+(BOOL)isValidateTelephoneNum:(NSString *)phone;
/**验证传真号码*/
+(BOOL)isValidateTelephone:(NSString *)phone;
/**验证字符串是否是数字*/
+(BOOL)isValidateNumber:(NSString *)number;
/**验证字符串是否全部是中文*/
+(BOOL)isValidateChinese:(NSString *)chineseName;
/**判断是否含有中文*/
+(BOOL)isContainChinese:(NSString *)chineseName;
/**获取AppVersion*/
+(NSString*)getAppVersion;
/**获取AppName*/
+(NSString*)getAppName;
/**获取App所支持的所有国际语言*/
+(NSString *)getAllSupportLanguage;
/**获取App当前的国际语言*/
+(NSString *)getCurrentLanguage;

/**判断字符串是否是纯净的Float*/
+(BOOL)isPureFloat:(NSString*)string;
/**判断字符串是否是纯净的Int*/
+(BOOL)isPureInt:(NSString*)string;

/**获取当前时间*/
+ (NSString *)currentDate;

/**去除前后空格*/
+ (NSString *)removeSpaceBeforeAndAfterWithString:(NSString *)str;

/**根据左右取中间字符串,返回为数组*/
+ (NSArray *)getMidStringBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString withText:(NSString *)text getOne:(BOOL)one withIndexStart:(NSInteger)startIndex stopString:(NSString *)stopString;

/**根据路径数组获取到目标字符串*/
+ (NSInteger)getStringFromPathArr:(NSArray *)pathArr
                            start:(NSInteger)start
                   stopPathString:(NSString *)stopPathstring
                         withText:(NSString *)text
                  saveToTargetStr:(NSMutableString *)targetStr;

/**从路径中获取指定字符串*/
+ (NSString *)getStringFromPathArr:(NSArray *)pathArr stopPathString:(NSString *)stopPathstring withText:(NSString *)text BetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString;

/**返回指定目标字符串在总字符串中的个数*/
+ (NSInteger)getCountTargetString:(NSString *)targetStr inText:(NSString *)text;

/**返回指定目标字符串在总字符串中的个数*/
+ (NSInteger)getCountLeftString:(NSString *)leftString rightString:(NSString *)rightString priorityIsLeft:(BOOL)isLeft notContainStringArr:(NSArray *)notContainStringArr inText:(NSString *)text;

/**是否在某两个字符串中间*/
+ (BOOL)isBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString targetStringRange:(NSRange)range inText:(NSString *)text;

/**是否在某两个字符串中间*/
+ (BOOL)hasBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString targetString:(NSString *)targetString inText:(NSString *)text;

+ (NSString *)removeSpacePrefix:(NSString *)text;
+ (NSString *)removeSpaceSuffix:(NSString *)text;

/**判断最后文本中的那一行是否存在一个目标字符串*/
+(BOOL)hasTarget:(NSString *)target inTheRow:(NSString *)text;
@end
