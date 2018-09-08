#import "ZHNSString.h"

@implementation ZHNSString
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)isValidatePassword:(NSString *)pw {
    NSString *emailRegex = @"[A-Z0-9a-z_]{6,15}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:pw];
}
+(BOOL)isValidateNickname:(NSString *)nickName {
    NSString *emailRegex = @"[A-Z 0-9a-z\u4e00-\u9fa5]{1,15}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:nickName];
}
+(BOOL)isValidatePhoneNum:(NSString *)phone{
    NSString *phoneRegex = @"^((147)|((17|13|15|18)[0-9]))\\d{8}$";//@"\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{11}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
+(BOOL)isValidateTelephoneNum:(NSString *)phone{
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneTest evaluateWithObject:phone];
}
+(BOOL)isValidateTelephone:(NSString *)phone{
    NSString * PHS = @"(”^(\\d{3,4}-)\\d{7,8}$”)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    return [phoneTest evaluateWithObject:phone];
}
+ (BOOL)isValidateBankCardNumber: (NSString *)bankCardNumber{
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^([0-9]{16}|[0-9]{19})$";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}
+(BOOL)isValidateNumber:(NSString *)number{
    NSString * num = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",num];
    return [numberTest evaluateWithObject:number];
}
+(BOOL)isValidateChinese:(NSString *)chineseName{
    NSString *chineseStr = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseStr];
    return [chineseTest evaluateWithObject:chineseName];
}
+(BOOL)isContainChinese:(NSString *)chineseName{
    unichar ch;
    
    for (NSInteger i=0; i<chineseName.length; i++) {
        ch=[chineseName characterAtIndex:i];
        if (ch>=19968&&ch<=40908) {
            return YES;
        }
    }
    return NO;
}


+(NSString*)getAppVersion
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

+(NSString*)getAppName
{
    NSDictionary* infoDictionary=[[NSBundle mainBundle]infoDictionary];
    NSString* appName=[infoDictionary objectForKey:@"CFBundleDisplayName"];
    return appName;
}

+(NSString *)getAllSupportLanguage{
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages"];
    return [NSString stringWithFormat:@"%@" , languages];
}

+(NSString *)getCurrentLanguage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return [NSString stringWithFormat:@"%@" , currentLanguage];
}

+(BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan=[NSScanner scannerWithString:string];
    float val;
    BOOL isFloat = [scan scanFloat:&val]&&[scan isAtEnd];
    if ([self isPureInt:string]) {
        return NO;
    }
    return isFloat;
}

+(BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan=[NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val]&&[scan isAtEnd];
}


+ (NSString *)currentDate{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

//去除前后空格
+ (NSString *)removeSpaceBeforeAndAfterWithString:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSArray *)getMidStringBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString withText:(NSString *)text getOne:(BOOL)one withIndexStart:(NSInteger)startIndex stopString:(NSString *)stopString{
    
    if (startIndex>=text.length-1) {
        return nil;
    }
    
    NSMutableArray *arrM=[NSMutableArray array];
    
    NSInteger indexStart=[text rangeOfString:leftString options:NSLiteralSearch range:NSMakeRange(startIndex, text.length-startIndex)].location;
    NSInteger indexEnd;
    NSInteger stopIndex=0;
    if (indexStart!=NSNotFound&&indexStart<text.length-1) {
        indexEnd=[text rangeOfString:rightString options:NSLiteralSearch range:NSMakeRange(indexStart+1, text.length-indexStart-1)].location;
        
        if (stopString.length==0) {
            stopIndex=text.length+1;
        }else{
            stopIndex=[text rangeOfString:rightString options:NSLiteralSearch range:NSMakeRange(indexStart+1, text.length-indexStart-1)].location;
        }
    }else{
        indexEnd=NSNotFound;
    }
    
    while (indexStart!=NSNotFound&&indexEnd!=NSNotFound&&indexStart<indexEnd&&indexEnd<stopIndex) {
        [arrM addObject:[text substringWithRange:NSMakeRange(indexStart+leftString.length, indexEnd-indexStart-leftString.length)]];
        
        if (one) {
            break;
        }
        
        indexStart=indexEnd+1;
        
        indexStart=[text rangeOfString:leftString options:NSLiteralSearch range:NSMakeRange(indexStart, text.length-indexStart)].location;
        if (indexStart!=NSNotFound&&indexStart<text.length-1) {
            indexEnd=[text rangeOfString:rightString options:NSLiteralSearch range:NSMakeRange(indexStart+1, text.length-indexStart-1)].location;
        }else break;
    }
    return arrM;
}

/**根据路径数组获取到目标字符串*/
+ (NSInteger)getStringFromPathArr:(NSArray *)pathArr
                            start:(NSInteger)start
                   stopPathString:(NSString *)stopPathstring
                         withText:(NSString *)text
                  saveToTargetStr:(NSMutableString *)targetStr{
    NSInteger index=start;
    NSInteger startIndex=0;
    NSInteger endIndex=0;
    BOOL success=YES;
    if(pathArr.count>0){
        NSInteger count=0;
        for (NSString *path in pathArr) {
            
            index=[text rangeOfString:path options:NSLiteralSearch range:NSMakeRange(index, text.length-index)].location;
            if (count==0) {
                startIndex=index;
                endIndex=[text rangeOfString:stopPathstring options:NSLiteralSearch range:NSMakeRange(index, text.length-index)].location;
                if (endIndex==NSNotFound) {
                    endIndex=0;
                }
            }else{
                if (index>endIndex) {
                    success=NO;
                    break;
                }
            }
            count++;
            
            if (index!=NSNotFound) {
                continue;
            }else{
                success=NO;
                break;
            }
        }
        if (success==NO) {
            return NSNotFound;
        }
        
        if (startIndex!=NSNotFound&&endIndex!=NSNotFound) {
            [targetStr setString:[text substringWithRange:NSMakeRange(startIndex, endIndex-startIndex)]];
            return endIndex+1;
        }
    }
    return NSNotFound;
}

/**从路径中获取指定字符串*/
+ (NSString *)getStringFromPathArr:(NSArray *)pathArr
                    stopPathString:(NSString *)stopPathstring
                          withText:(NSString *)text
                 BetweenLeftString:(NSString *)leftString
                       RightString:(NSString *)rightString{
    NSInteger index=0;
    BOOL success=YES;
    if(pathArr.count>0){
        for (NSString *path in pathArr) {
            index=[text rangeOfString:path options:NSLiteralSearch range:NSMakeRange(index, text.length-index)].location;
            if (index!=NSNotFound) {
                continue;
            }else{
                success=NO;
                break;
            }
        }
        if (success==NO) {
            return @"";
        }
        
        NSArray *myStrings=[self getMidStringBetweenLeftString:leftString
                                                   RightString:rightString
                                                      withText:text
                                                        getOne:YES
                                                withIndexStart:index
                                                    stopString:stopPathstring];
        
        if (myStrings.count>0) {
            return myStrings[0];
        }
    }
    return @"";
}

/**返回指定目标字符串在总字符串中的个数*/
+ (NSInteger)getCountTargetString:(NSString *)targetStr inText:(NSString *)text{
    NSInteger count=0;
    NSInteger indexStart=[text rangeOfString:targetStr].location;
    while (indexStart!=NSNotFound) {
        count++;
        
        indexStart+=targetStr.length;
        
        if (indexStart<text.length-1) {
            indexStart=[text rangeOfString:targetStr options:NSLiteralSearch range:NSMakeRange(indexStart, text.length-indexStart)].location;
        }else break;
    }
    return count;
}

/**返回指定目标字符串在总字符串中的个数*/
+ (NSInteger)getCountLeftString:(NSString *)leftString rightString:(NSString *)rightString priorityIsLeft:(BOOL)isLeft notContainStringArr:(NSArray *)notContainStringArr inText:(NSString *)text{
    if (isLeft==YES) {
        return [self getCountLeftString:leftString rightString:rightString notContainStringArr:notContainStringArr inText:text];
    }
    return [self getCountRightString:rightString LeftString:leftString notContainStringArr:notContainStringArr inText:text];
}

/**返回指定目标字符串在总字符串中的个数*/
+ (NSInteger)getCountLeftString:(NSString *)leftString rightString:(NSString *)rightString notContainStringArr:(NSArray *)notContainStringArr inText:(NSString *)text{
    NSInteger count=0;
    NSInteger indexStart=[text rangeOfString:leftString].location;
    NSInteger endStart;
    while (indexStart!=NSNotFound) {
        
        endStart=[text rangeOfString:rightString options:NSLiteralSearch range:NSMakeRange(indexStart+1, text.length-indexStart-1)].location;
        
        if (endStart!=NSNotFound) {
            
            NSString *tempString=[text substringWithRange:NSMakeRange(indexStart+leftString.length, endStart-indexStart-leftString.length)];
            BOOL qualified=YES;
            
            for (NSString *str in notContainStringArr) {
                if ([tempString rangeOfString:str].location!=NSNotFound) {
                    qualified=NO;
                    break;
                }
            }
            
            if (qualified==YES) {
                count++;
                indexStart=endStart+1;
            }else{
                indexStart++;
            }
            
            if (indexStart<text.length-1) {
                indexStart=[text rangeOfString:
                            leftString options:NSLiteralSearch
                                         range:NSMakeRange(indexStart, text.length-indexStart)].location;
            }else break;
        }else{
            break;
        }
    }
    return count;
}

/**返回指定目标字符串在总字符串中的个数*/
+ (NSInteger)getCountRightString:(NSString *)rightString
                      LeftString:(NSString *)leftString
             notContainStringArr:(NSArray *)notContainStringArr
                          inText:(NSString *)text{
    NSInteger count=0;
    NSInteger indexStart=0;
    NSInteger endStart=[text rangeOfString:rightString].location;
    while (endStart!=NSNotFound) {
        
        indexStart=[text rangeOfString:leftString
                               options:NSBackwardsSearch|NSLiteralSearch
                                 range:NSMakeRange(indexStart, endStart-indexStart)].location;
        
        if (indexStart!=NSNotFound) {
            
            NSString *tempString=[text substringWithRange:NSMakeRange(indexStart+leftString.length, endStart-indexStart-leftString.length)];
            BOOL qualified=YES;
            
            for (NSString *str in notContainStringArr) {
                if ([tempString rangeOfString:str].location!=NSNotFound) {
                    qualified=NO;
                    break;
                }
            }
            
            if (qualified==YES) {
                count++;
            }
            
            endStart++;
            indexStart=endStart;
            
            if (endStart<text.length-1) {
                endStart=[text rangeOfString:rightString
                                     options:NSLiteralSearch
                                       range:NSMakeRange(endStart, text.length-endStart)].location;
            }else break;
        }else{
            break;
        }
    }
    return count;
}

/**是否在某两个字符串中间*/
+ (BOOL)isBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString targetStringRange:(NSRange)range inText:(NSString *)text{
    if (range.location+range.length>text.length) {
        return NO;
    }
    NSString *targetString=[text substringWithRange:range];
    if ([text rangeOfString:targetString].location!=NSNotFound) {
        NSInteger index=range.location;
        
        NSInteger leftStringAtLeftIndex,rightStringAtLeftIndex,rightStringAtRightIndex,leftStringAtRightIndex = 0;
        //        leftStringAtLeftIndex 左边的字符串在左边的位置
        //        rightStringAtLeftIndex 右边的字符串在左边的位置
        //        rightStringAtRightIndex 右边的字符串在右边的位置
        //        leftStringAtRightIndex 左边的字符串在右边的位置
        
        leftStringAtLeftIndex=[text rangeOfString:leftString options:NSBackwardsSearch|NSLiteralSearch range:NSMakeRange(0, index)].location;
        if (leftStringAtLeftIndex!=NSNotFound&&[leftString rangeOfString:rightString].location!=NSNotFound) {
            rightStringAtLeftIndex=[text rangeOfString:rightString options:NSBackwardsSearch|NSLiteralSearch range:NSMakeRange(0, leftStringAtLeftIndex)].location;
        }else
            rightStringAtLeftIndex=[text rangeOfString:rightString options:NSBackwardsSearch|NSLiteralSearch range:NSMakeRange(0, index)].location;
        
        rightStringAtRightIndex=[text rangeOfString:rightString options:NSLiteralSearch range:NSMakeRange(index+targetString.length, text.length-index-targetString.length)].location;
        if (rightStringAtRightIndex!=NSNotFound&&[rightString rangeOfString:leftString].location!=NSNotFound) {
            leftStringAtRightIndex=[text rangeOfString:leftString options:NSLiteralSearch range:NSMakeRange(leftStringAtRightIndex+targetString.length, text.length-leftStringAtRightIndex-targetString.length)].location;
        }else{
            leftStringAtRightIndex=[text rangeOfString:leftString options:NSLiteralSearch range:NSMakeRange(index+targetString.length, text.length-index-targetString.length)].location;
        }
        
        /**满足以下条件*/
        if (leftStringAtLeftIndex!=NSNotFound) {//如果左边的字符串存在
            if (rightStringAtLeftIndex!=NSNotFound&&rightStringAtLeftIndex>leftStringAtLeftIndex) {//如果rightString的字符串也有存在在左边,并且更靠近目标字符串
                return NO;
            }else{
                if (rightStringAtRightIndex!=NSNotFound) {//如果有边的字符串存在
                    if (leftStringAtRightIndex!=NSNotFound&&rightStringAtRightIndex>leftStringAtRightIndex) {//如果leftString的字符串也有存在在右边,并且更靠近目标字符串
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    return NO;
                }
            }
        }else{
            return NO;
        }
    }
    return NO;
}

/**是否在某两个字符串中间*/
+ (BOOL)hasBetweenLeftString:(NSString *)leftString RightString:(NSString *)rightString targetString:(NSString *)targetString inText:(NSString *)text{
    NSRange range=[text rangeOfString:targetString];
    while (range.location!=NSNotFound) {
        if ([self isBetweenLeftString:leftString RightString:rightString targetStringRange:range inText:text]) {
            return YES;
        }
        range=[text rangeOfString:targetString options:NSLiteralSearch range:NSMakeRange(range.location+1, text.length-range.location-1)];
    }
    return NO;
}

+ (NSString *)removeSpacePrefix:(NSString *)text{
    if ([text hasPrefix:@" "]) {
        text=[text substringFromIndex:1];
        return [self removeSpacePrefix:text];
    }
    else if([text hasPrefix:@"\t"]){
        text=[text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        return [self removeSpacePrefix:text];
    }else
        return text;
}
+ (NSString *)removeSpaceSuffix:(NSString *)text{
    if ([text hasSuffix:@" "]) {
        text=[text substringToIndex:text.length-1];
        return [self removeSpaceSuffix:text];
    }
    else if([text hasSuffix:@"\t"]){
        text=[text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        return [self removeSpaceSuffix:text];
    }else
        return text;
}

/**判断最后文本中的那一行是否存在一个目标字符串*/
+ (BOOL)hasTarget:(NSString *)target inTheRow:(NSString *)text{
    NSString *tempText;
    NSInteger index=[text rangeOfString:@"\n" options:NSBackwardsSearch].location;
    if (index==NSNotFound) {
        tempText=text;
    }else{
        tempText=[text substringWithRange:NSMakeRange(index, text.length-index)];
    }
    NSInteger indexAnnotation=[tempText rangeOfString:target].location;
    if (indexAnnotation!=NSNotFound) {
        return YES;
    }
    return NO;
}

@end
