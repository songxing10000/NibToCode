#import "ZHStoryboardTextManagerToFrameMVC.h"
#import "ZHStroyBoardToFrameModel.h"

@implementation ZHStoryboardTextManagerToFrameMVC
/**创建约束代码*/
+ (NSString *)getCreatConstraintCodeWithIdStr:(NSString *)idStr WithViewName:(NSString *)viewName withConstraintDic:(NSDictionary *)constraintDic withSelfConstraintDic:(NSDictionary *)selfConstraintDic withOutletView:(NSDictionary *)outletView isCell:(BOOL)isCell withDoneArrM:(NSMutableArray *)doneArrM withCustomAndNameDic:(NSDictionary *)customAndNameDic addToFatherView:(NSString *)fatherView isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews withProperty:(ViewProperty *)property replaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM doneViewArrM:(NSMutableArray *)doneViewArrM viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM omissionsFrameViews:(NSMutableArray *)omissionsFrameViews{
    
    if (constraintDic.count==0) {
        return @"";
    }
    
    NSMutableString *textCode=[NSMutableString string];
    
    [textCode appendFormat:@"%@.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);",viewName];
    
    NSMutableString *x=[NSMutableString string],*y=[NSMutableString string],*w=[NSMutableString string],*h=[NSMutableString string];
    
    if ([fatherView hasPrefix:@"self.view"]) {
        fatherView=@"self.view";
    }
    if ([fatherView hasSuffix:@"CollectionViewCell"]||[fatherView hasSuffix:@"TableViewCell"]) {
        fatherView=@"self.contentView";
    }
    
    NSArray *constraintArr=constraintDic[viewName];
    if (constraintArr.count>0) {
        for (NSDictionary *constraintSubDic in constraintArr) {
            
            //每一个具体的约束
            
            NSString *firstAttribute=constraintSubDic[@"firstAttribute"];
            NSString *firstItem=constraintSubDic[@"firstItem"];
            NSString *secondAttribute=constraintSubDic[@"secondAttribute"];
            NSString *secondItem=constraintSubDic[@"secondItem"];
            NSString *multiplier=constraintSubDic[@"multiplier"];
            NSString *constant=constraintSubDic[@"constant"];
            NSString *idStr=constraintSubDic[@"id"];
            
            if ([firstItem hasPrefix:@"self.view"]) {
                firstItem=@"self.view";
            }
            if ([secondItem hasPrefix:@"self.view"]) {
                secondItem=@"self.view";
            }
            
            if ([firstItem hasSuffix:@"CollectionViewCell"]||[firstItem hasSuffix:@"TableViewCell"]) {
                firstItem=@"self.contentView";
            }
            if ([secondItem hasSuffix:@"CollectionViewCell"]||[secondItem hasSuffix:@"TableViewCell"]) {
                secondItem=@"self.contentView";
            }
            
            if([self isSystemIdStr:firstItem]){
                if (isCell) {
                    firstItem=@"self.contentView";
                }else{
                    firstItem=fatherView;
                }
            }else{
                if (firstItem.length>0&&[self isView:firstItem]&&[firstItem isEqualToString:@"self.view"]==NO&&[firstItem isEqualToString:@"self.contentView"]==NO&&[doneArrM containsObject:firstItem]==NO) {
                    
                    [textCode insertString:[self getCreateViewCodeWithIdStr:firstItem WithViewName:firstItem withViewCategoryName:customAndNameDic[firstItem] withOutletView:outletView addToFatherView:fatherView withDoneArrM:doneArrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:idAndOutletViews] atIndex:0];
                }
            }
            
            if([self isSystemIdStr:secondItem]){
                if (isCell) {
                    secondItem=@"self.contentView";
                }else{
                    secondItem=fatherView;
                }
            }else{
                if (secondItem.length>0&&[self isView:secondItem]&&[secondItem isEqualToString:@"self.view"]==NO&&[firstItem isEqualToString:@"self.contentView"]==NO&&[doneArrM containsObject:secondItem]==NO) {
                    
                    [textCode insertString:[self getCreateViewCodeWithIdStr:secondItem WithViewName:secondItem withViewCategoryName:customAndNameDic[secondItem] withOutletView:outletView addToFatherView:fatherView withDoneArrM:doneArrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:idAndOutletViews] atIndex:0];
                    
                }
            }
            
            //1.如果该约束的第一对象是自己
            if ([firstItem isEqualToString:viewName]) {
                
                if (secondItem.length>0) {//第2对象存在
                    
                    if(secondAttribute.length>0){
                        if ([secondItem hasPrefix:@"self."]) {
                            if(constant.length>0){
                                if ([firstAttribute isEqualToString:@"trailing"]||[firstAttribute isEqualToString:@"bottom"]) {
                                    constant=[@"-" stringByAppendingString:constant];
                                }else{
                                    constant=[@"+" stringByAppendingString:constant];
                                }
                                [self get_top_leading_centerX_centerY_bottom_height_width_trailing_X:x Y:y W:w H:h attribute:firstAttribute firstItem:secondItem secondAttribute:firstAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }else{
                                [self get_top_leading_centerX_centerY_bottom_height_width_trailing_X:x Y:y W:w H:h attribute:firstAttribute firstItem:secondItem secondAttribute:firstAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }
                        }else{
                            if(constant.length>0){
                                if (([firstAttribute isEqualToString:@"trailing"]||[firstAttribute isEqualToString:@"bottom"])&&[firstAttribute isEqualToString:secondAttribute]) {
                                    constant=[@"-" stringByAppendingString:constant];
                                }else{
                                    constant=[@"+" stringByAppendingString:constant];
                                }
                                [self get_top_leading_centerX_centerY_bottom_height_width_trailing_X:x Y:y W:w H:h attribute:firstAttribute firstItem:secondItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }else{
                                [self get_top_leading_centerX_centerY_bottom_height_width_trailing_X:x Y:y W:w H:h attribute:firstAttribute firstItem:secondItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }
                        }
                        
                    }else{
                        NSLog(@"%@",@"约束很奇怪  有secondItem 没有 secondAttribute");
                    }
                    
                }else{//第2对象不存在
                    if(constant.length>0){
                        [[self getFrame_X_Y_W_H:x Y:y W:w H:h attribute:firstAttribute fatherView:fatherView isChild:NO] setString:constant];
                    }
                    else{
                        NSLog(@"%@",@"约束很奇怪  宽高没有值");
                    }
                }
                
            }
            else if ([secondItem isEqualToString:viewName]){
                
                if (firstItem.length>0&&[self isSystemIdStr:firstItem]==NO) {
                    if(firstAttribute.length>0){
                        
                        if ([firstItem hasPrefix:@"self."]) {
                            if(constant.length>0){
                                if ([secondAttribute isEqualToString:@"trailing"]||[secondAttribute isEqualToString:@"bottom"]) {
                                    constant=[@"-" stringByAppendingString:constant];
                                }else{
                                    constant=[@"+" stringByAppendingString:constant];
                                }
                                [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }else{
                                [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }
                        }else{
                            if(constant.length>0){
                                if (([firstAttribute isEqualToString:@"trailing"]||[firstAttribute isEqualToString:@"bottom"])&&[firstAttribute isEqualToString:secondAttribute]) {
                                    constant=[@"-" stringByAppendingString:constant];
                                }else{
                                    constant=[@"+" stringByAppendingString:constant];
                                }
                                [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }else{
                                [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }
                        }
                        
                    }else{
                        NSLog(@"%@",@"约束很奇怪  有firstItem 没有 firstAttribute");
                    }
                }else{
                    if (selfConstraintDic[viewName]!=nil) {
                        BOOL isSelfConstraint=NO;
                        for (NSDictionary *dicTemp in selfConstraintDic[viewName]) {
                            if([dicTemp[@"id"] isEqualToString:idStr]){
                                isSelfConstraint=YES;
                                break;
                            }
                        }
                        if (isSelfConstraint==YES) {
                            if (firstItem.length<=0) {
                                if (isCell) {
                                    firstItem=viewName;
                                }else{
                                    firstItem=fatherView;
                                }
                            }
                            if(constant.length>0){
                                if ([secondAttribute isEqualToString:@"trailing"]||[secondAttribute isEqualToString:@"bottom"]) {
                                    constant=[@"-" stringByAppendingString:constant];
                                }else{
                                    constant=[@"+" stringByAppendingString:constant];
                                }
                                [self get_height_equalTo_width_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:firstAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }else{
                                [self get_height_equalTo_width_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:firstAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }
                        }else{
                            if (firstItem.length<=0) {
                                if (firstAttribute.length>0&&secondAttribute.length>0) {
                                    firstItem=fatherView;
                                }else{
                                    if (isCell) {
                                        firstItem=@"self.contentView";
                                    }else{
                                        firstItem=@"self.view";
                                    }
                                }
                            }
                            if(constant.length>0){
                                if ([secondAttribute isEqualToString:@"trailing"]||[secondAttribute isEqualToString:@"bottom"]) {
                                    constant=[@"-" stringByAppendingString:constant];
                                }else{
                                    constant=[@"+" stringByAppendingString:constant];
                                }
                                [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }else{
                                [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                            }
                        }
                    }else{
                        if (firstItem.length<=0) {
                            if (firstAttribute.length>0&&secondAttribute.length>0) {
                                firstItem=fatherView;
                            }else{
                                if (isCell) {
                                    firstItem=@"self.contentView";
                                }else{
                                    firstItem=@"self.view";
                                }
                            }
                        }
                        if(constant.length>0){
                            if ([secondAttribute isEqualToString:@"trailing"]||[secondAttribute isEqualToString:@"bottom"]) {
                                constant=[@"-" stringByAppendingString:constant];
                            }else{
                                constant=[@"+" stringByAppendingString:constant];
                            }
                            [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                        }else{
                            [self get_bottom_trailing_X:x Y:y W:w H:h attribute:secondAttribute firstItem:firstItem secondAttribute:secondAttribute constant:constant multiplier:[self getmultiplier:multiplier] fatherView:fatherView withProperty:property replaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM viewName:viewName viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews];
                        }
                    }
                }
            }
            else{
                if (firstAttribute.length>0) {
                    [[self getFrame_X_Y_W_H:x Y:y W:w H:h attribute:firstAttribute fatherView:fatherView isChild:NO] setString:constant];
                }
                else{
                    NSLog(@"%@",@"约束很奇怪  没有firstAttribute");
                }
            }
        }
    }
    
    if (w.length<=0) [w setString:property.rect_w];
    if (h.length<=0) [h setString:property.rect_h];
    
    [viewsFrameDicM setValue:[NSString stringWithFormat:@"%@,%@,%@,%@",x,y,w,h] forKey:viewName];
    if (x.length<=0||y.length<=0) {
        [omissionsFrameViews addObject:viewName];
        if (x.length<=0)[x setString:[NSString stringWithFormat:@"<#%@.X#>",viewName]];
        else [y setString:[NSString stringWithFormat:@"<#%@.Y#>",viewName]];
    }
    [textCode setString:[textCode stringByReplacingOccurrencesOfString:@"<#CGFloat x#>" withString:x]];
    [textCode setString:[textCode stringByReplacingOccurrencesOfString:@"<#CGFloat y#>" withString:y]];
    [textCode setString:[textCode stringByReplacingOccurrencesOfString:@"<#CGFloat width#>" withString:w]];
    [textCode setString:[textCode stringByReplacingOccurrencesOfString:@"<#CGFloat height#>" withString:h]];
    [textCode appendString:@"\n"];
    
    if ([doneViewArrM containsObject:viewName]==NO) {
        [doneViewArrM addObject:viewName];
    }
//    NSLog(@"X=%@,Y=%@,W=%@,H=%@",x,y,w,h);
    
    //解决multipliedBy(m:n)的问题
    [self dealWith_multipliedBy:textCode];
    //解决.offset(--n)的问题
    [self dealWith_offset:textCode];
    [self dealWith_zero:textCode];
    
    [textCode appendString:@"\n"];
    return textCode;
}
+ (void)dealWith_zero:(NSMutableString *)textCode{
    [textCode setString:[textCode stringByReplacingOccurrencesOfString:@"(0+" withString:@"("]];
    [textCode setString:[textCode stringByReplacingOccurrencesOfString:@" 0+" withString:@""]];
    [textCode setString:[textCode stringByReplacingOccurrencesOfString:@",0+" withString:@","]];
}

+ (NSString *)getmultiplier:(NSString *)multiplier{
    
    NSString *newStr;
    if ([multiplier rangeOfString:@":"].location!=NSNotFound) {
        newStr=[multiplier stringByReplacingOccurrencesOfString:@":" withString:@"/"];
        newStr=[newStr stringByAppendingString:@".0"];
        return newStr;
    }
    return @"";
}

+ (BOOL)storeReplaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM doneViewArrM:(NSMutableArray *)doneViewArrM firstItem:(NSString *)firstItem secondItem:(NSString *)secondItem firstAttribute:(NSString *)firstAttribute secondAttribute:(NSString *)secondAttribute constant:(NSString *)constant multiplier:(NSString *)multiplier viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM omissionsFrameViews:(NSMutableArray *)omissionsFrameViews isChild:(BOOL)isChild{
    //前者这个是提前存取有用的约束信息                          //后者这个是补上有用的约束信息
    if ([doneViewArrM containsObject:secondItem]==NO||[omissionsFrameViews containsObject:secondItem]) {
        ZHStroyBoardToFrameModel *model=[ZHStroyBoardToFrameModel new];
        model.firstItem=firstItem;model.secondItem=secondItem;model.firstAttribute=firstAttribute;model.secondAttribute=secondAttribute;model.constant=constant;model.multiplier=multiplier;model.isChild=isChild;
        [replaceLayoutsDicM setValue:model forKey:[NSString stringWithFormat:@"%@-%@-%@-%@",firstItem,firstAttribute,secondItem,secondAttribute]];
//        NSLog(@"%@-%@-%@",secondItem,firstItem,secondAttribute);
        if([doneViewArrM containsObject:secondItem]==NO)return YES;
    }
    return NO;
}

+ (NSMutableString *)getFrame_X_Y_W_H:(NSMutableString *)X Y:(NSMutableString *)Y W:(NSMutableString *)W H:(NSMutableString *)H attribute:(NSString *)attribute fatherView:(NSString *)fatherView isChild:(BOOL)isChild{
    if (isChild) {
        if([attribute isEqualToString:@"height"]){
            return H;
        }
        if([attribute isEqualToString:@"bottom"]){
            if (H.length>0) return Y;
            return H;
        }
        if([attribute isEqualToString:@"width"]){
            return W;
        }
        if([attribute isEqualToString:@"trailing"]){
            if (W.length>0) return X;
            return W;
        }
        if([attribute isEqualToString:@"leading"]||[attribute isEqualToString:@"centerX"]){
            return X;
        }
        if([attribute isEqualToString:@"top"]||[attribute isEqualToString:@"centerY"]){
            return Y;
        }
    }else{
        if([attribute isEqualToString:@"height"]){
            return H;
        }
        if([attribute isEqualToString:@"width"]){
            return W;
        }
        if([attribute isEqualToString:@"leading"]||[attribute isEqualToString:@"centerX"]||[attribute isEqualToString:@"trailing"]){
            return X;
        }
        if([attribute isEqualToString:@"top"]||[attribute isEqualToString:@"centerY"]||[attribute isEqualToString:@"bottom"]){
            return Y;
        }
    }
    return [NSMutableString string];
}

+ (void)get_height_equalTo_width_X:(NSMutableString *)X Y:(NSMutableString *)Y W:(NSMutableString *)W H:(NSMutableString *)H attribute:(NSString *)attribute firstItem:(NSString *)firstItem secondAttribute:(NSString *)secondAttribute constant:(NSString *)constant multiplier:(NSString *)multiplier fatherView:(NSString *)fatherView withProperty:(ViewProperty *)property replaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM doneViewArrM:(NSMutableArray *)doneViewArrM viewName:(NSString *)viewName viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM omissionsFrameViews:(NSMutableArray *)omissionsFrameViews{
    //    NSLog(@"make.%@.equalTo(%@.mas_%@).with.offset(%@)",secondAttribute,firstItem,firstAttribute,constant);
    BOOL isChild=[firstItem isEqualToString:fatherView];
    if ([self storeReplaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM firstItem:viewName secondItem:firstItem firstAttribute:attribute secondAttribute:secondAttribute constant:constant multiplier:multiplier viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews isChild:isChild]) {
        return;
    }
    
    NSMutableString *tempStrM=[self getFrame_X_Y_W_H:X Y:Y W:W H:H attribute:attribute fatherView:fatherView isChild:isChild];
    if (isChild) {
        if ([secondAttribute isEqualToString:@"width"]) {
            [tempStrM setString:[NSString stringWithFormat:@"%@.width",firstItem]];
        }else if ([secondAttribute isEqualToString:@"height"]){
            [tempStrM setString:[NSString stringWithFormat:@"%@.height",firstItem]];
        }
        if (constant.length>0) [tempStrM setString:[tempStrM stringByAppendingString:constant]];
        if (multiplier.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@)*%@",tempStrM,multiplier]];
    }else{
        if ([secondAttribute isEqualToString:@"width"]) {
            [tempStrM setString:[NSString stringWithFormat:@"%@.width",firstItem]];
        }else if ([secondAttribute isEqualToString:@"height"]){
            [tempStrM setString:[NSString stringWithFormat:@"%@.height",firstItem]];
        }
        if (constant.length>0) [tempStrM setString:[tempStrM stringByAppendingString:constant]];
        if (multiplier.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@)*%@",tempStrM,multiplier]];
    }
}

+ (void)get_bottom_trailing_X:(NSMutableString *)X Y:(NSMutableString *)Y W:(NSMutableString *)W H:(NSMutableString *)H attribute:(NSString *)attribute firstItem:(NSString *)firstItem secondAttribute:(NSString *)secondAttribute constant:(NSString *)constant multiplier:(NSString *)multiplier fatherView:(NSString *)fatherView withProperty:(ViewProperty *)property replaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM doneViewArrM:(NSMutableArray *)doneViewArrM viewName:(NSString *)viewName viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM omissionsFrameViews:(NSMutableArray *)omissionsFrameViews{
//    NSLog(@"make.%@.equalTo(%@.mas_%@).with.offset(%@)",secondAttribute,firstItem,secondAttribute,constant);
    BOOL isChild=[firstItem isEqualToString:fatherView];
    if ([self storeReplaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM firstItem:viewName secondItem:firstItem firstAttribute:attribute secondAttribute:secondAttribute constant:constant multiplier:multiplier viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews isChild:isChild]) {
        return;
    }
    NSMutableString *tempStrM=[self getFrame_X_Y_W_H:X Y:Y W:W H:H attribute:attribute fatherView:fatherView isChild:isChild];
    if (isChild) {
        if ([secondAttribute isEqualToString:@"trailing"]) {
            if (W.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@.width-%@)",firstItem,W]];
            else{
                if (X.length>0){//说明是完全没有width的约束或者不是带默认width的控件
                    [tempStrM setString:[NSString stringWithFormat:@"(%@.width-(%@))",firstItem,X]];
                }else [tempStrM setString:[NSString stringWithFormat:@"(%@.width-%@)",firstItem,property.rect_w]];//如果是加到父视图上面,一般来说,宽高约束是优先的,如果不是,这里也需要优先填入宽高
            }
        }else if ([secondAttribute isEqualToString:@"bottom"]){
            if (H.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@.height-%@)",firstItem,H]];
            else{
                if (Y.length>0) {//说明是完全没有height的约束或者不是带默认height的控件
                    [tempStrM setString:[NSString stringWithFormat:@"(%@.height-(%@))",firstItem,Y]];
                }else [tempStrM setString:[NSString stringWithFormat:@"(%@.height-%@)",firstItem,property.rect_h]];//如果是加到父视图上面,一般来说,宽高约束是优先的,如果不是,这里也需要优先填入宽高
            }
        }
        if (constant.length>0) [tempStrM setString:[tempStrM stringByAppendingString:constant]];
        if (multiplier.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@)*%@",tempStrM,multiplier]];
    }else{
        if ([secondAttribute isEqualToString:@"trailing"]) {
            [tempStrM setString:[NSString stringWithFormat:@"CGRectGetMaxX(%@.frame)",firstItem]];
        }else if ([secondAttribute isEqualToString:@"bottom"]){
            [tempStrM setString:[NSString stringWithFormat:@"CGRectGetMaxY(%@.frame)",firstItem]];
        }
        if (constant.length>0) [tempStrM setString:[tempStrM stringByAppendingString:constant]];
        if (multiplier.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@)*%@",tempStrM,multiplier]];
    }
}

+ (void)get_top_leading_centerX_centerY_bottom_height_width_trailing_X:(NSMutableString *)X Y:(NSMutableString *)Y W:(NSMutableString *)W H:(NSMutableString *)H attribute:(NSString *)attribute firstItem:(NSString *)firstItem secondAttribute:(NSString *)secondAttribute constant:(NSString *)constant multiplier:(NSString *)multiplier fatherView:(NSString *)fatherView withProperty:(ViewProperty *)property replaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM doneViewArrM:(NSMutableArray *)doneViewArrM viewName:(NSString *)viewName viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM omissionsFrameViews:(NSMutableArray *)omissionsFrameViews{
//    NSLog(@"make.%@.equalTo(%@.mas_%@).with.offset(%@)",firstAttribute,secondItem,secondAttribute,constant);
    BOOL isChild=[firstItem isEqualToString:fatherView];
    if ([self storeReplaceLayoutsDicM:replaceLayoutsDicM doneViewArrM:doneViewArrM firstItem:viewName secondItem:firstItem firstAttribute:attribute secondAttribute:secondAttribute constant:constant multiplier:multiplier viewsFrameDicM:viewsFrameDicM omissionsFrameViews:omissionsFrameViews isChild:isChild]) {
        return;
    }
    NSMutableString *tempStrM=[self getFrame_X_Y_W_H:X Y:Y W:W H:H attribute:attribute fatherView:fatherView isChild:isChild];
    if (isChild) {
        if ([secondAttribute isEqualToString:@"top"]) {
            [tempStrM setString:[NSString stringWithFormat:@"0"]];
        }else if ([secondAttribute isEqualToString:@"bottom"]){
            if (H.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@.height-%@)",firstItem,H]];
            else{
                if (Y.length>0) {//说明是完全没有height的约束或者不是带默认height的控件
                    [tempStrM setString:[NSString stringWithFormat:@"(%@.height-(%@))",firstItem,Y]];
                }else [tempStrM setString:[NSString stringWithFormat:@"(%@.height-%@)",firstItem,property.rect_h]];//如果是加到父视图上面,一般来说,宽高约束是优先的,如果不是,这里也需要优先填入宽高
            }
        }else if ([secondAttribute isEqualToString:@"leading"]) {
            [tempStrM setString:[NSString stringWithFormat:@"0"]];
        }else if ([secondAttribute isEqualToString:@"trailing"]){
            if (W.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@.width-%@)",firstItem,W]];
            else{
                if (X.length>0){//说明是完全没有width的约束或者不是带默认width的控件
                    [tempStrM setString:[NSString stringWithFormat:@"(%@.width-(%@))",firstItem,X]];
                }else [tempStrM setString:[NSString stringWithFormat:@"(%@.width-%@)",firstItem,property.rect_w]];//如果是加到父视图上面,一般来说,宽高约束是优先的,如果不是,这里也需要优先填入宽高
            }
        }else if ([secondAttribute isEqualToString:@"centerX"]){
            if (W.length>0) [tempStrM setString:[NSString stringWithFormat:@"((%@.width-%@)/2.0)",firstItem,W]];
            else [tempStrM setString:[NSString stringWithFormat:@"((%@.width-%@)/2.0)",firstItem,property.rect_w]];
        }else if ([secondAttribute isEqualToString:@"centerY"]){
            if (H.length>0) [tempStrM setString:[NSString stringWithFormat:@"((%@.height-%@)/2.0)",firstItem,H]];
            else [tempStrM setString:[NSString stringWithFormat:@"((%@.height-%@)/2.0)",firstItem,property.rect_h]];
        }else if ([secondAttribute isEqualToString:@"width"]){
            [tempStrM setString:[NSString stringWithFormat:@"%@.width",firstItem]];
        }else if ([secondAttribute isEqualToString:@"height"]){
            [tempStrM setString:[NSString stringWithFormat:@"%@.height",firstItem]];
        }
        if (constant.length>0) [tempStrM setString:[tempStrM stringByAppendingString:constant]];
        if (multiplier.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@)*%@",tempStrM,multiplier]];
    }else{
        if ([secondAttribute isEqualToString:@"top"]) {
            [tempStrM setString:[NSString stringWithFormat:@"%@.y",firstItem]];
        }else if ([secondAttribute isEqualToString:@"bottom"]){
            [tempStrM setString:[NSString stringWithFormat:@"CGRectGetMaxY(%@.frame)",firstItem]];
        }else if ([secondAttribute isEqualToString:@"leading"]) {
            [tempStrM setString:[NSString stringWithFormat:@"%@.x",firstItem]];
        }else if ([secondAttribute isEqualToString:@"trailing"]){
            [tempStrM setString:[NSString stringWithFormat:@"CGRectGetMaxX(%@.frame)",firstItem]];
        }else if ([secondAttribute isEqualToString:@"centerX"]){
            if (W.length>0) [tempStrM setString:[NSString stringWithFormat:@"(CGRectGetMidX(%@.frame)-%@/2.0)",firstItem,W]];
            else [tempStrM setString:[NSString stringWithFormat:@"(CGRectGetMidX(%@.frame)-%@/2.0)",firstItem,property.rect_w]];
        }else if ([secondAttribute isEqualToString:@"centerY"]){
            if (H.length>0) [tempStrM setString:[NSString stringWithFormat:@"(CGRectGetMidY(%@.frame)-%@/2.0)",firstItem,H]];
            else [tempStrM setString:[NSString stringWithFormat:@"(CGRectGetMidY(%@.frame)-%@/2.0)",firstItem,property.rect_h]];
        }else if ([secondAttribute isEqualToString:@"width"]){
            [tempStrM setString:[NSString stringWithFormat:@"%@.width",firstItem]];
        }else if ([secondAttribute isEqualToString:@"height"]){
            [tempStrM setString:[NSString stringWithFormat:@"%@.height",firstItem]];
        }
        if (constant.length>0) [tempStrM setString:[tempStrM stringByAppendingString:constant]];
        if (multiplier.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@)*%@",tempStrM,multiplier]];
    }
}

+ (NSMutableString *)dealWithOmissionsFrameViewsWithCodeText:(NSMutableString *)codeText replaceLayoutsDicM:(NSMutableDictionary *)replaceLayoutsDicM viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM{
    NSArray *midStrings=[ZHNSString getMidStringBetweenLeftString:@"<#" RightString:@"#>" withText:codeText getOne:NO withIndexStart:0 stopString:@""];
    NSArray *replaceLayoutsDicMKeys=[replaceLayoutsDicM allKeys];
    for (NSString *midStr in midStrings) {
        NSString *viewName,*maybe_1,*maybe_2,*maybe_3;
        if ([midStr hasSuffix:@".X"]) {
            viewName=[midStr stringByReplacingOccurrencesOfString:@".X" withString:@""];
            maybe_1=[NSString stringWithFormat:@"%@-%@",viewName,@"leading"];
            maybe_2=[NSString stringWithFormat:@"%@-%@",viewName,@"centerX"];
            maybe_3=[NSString stringWithFormat:@"%@-%@",viewName,@"trailing"];
            
            
        }else if([midStr hasSuffix:@".Y"]) {
            viewName=[midStr stringByReplacingOccurrencesOfString:@".Y" withString:@""];
            maybe_1=[NSString stringWithFormat:@"%@-%@",viewName,@"top"];
            maybe_2=[NSString stringWithFormat:@"%@-%@",viewName,@"bottom"];
            maybe_3=[NSString stringWithFormat:@"%@-%@",viewName,@"centerY"];
            
        }
        int foundCount=0;
        
        for (NSString *key in replaceLayoutsDicMKeys) {
            for (NSString *maybe in @[maybe_1,maybe_2,maybe_3]) {
                if ([key rangeOfString:maybe].location!=NSNotFound) {
                    ZHStroyBoardToFrameModel *model=(ZHStroyBoardToFrameModel *)replaceLayoutsDicM[key];
//                    NSLog(@"key=%@",key);
                    NSString *result=[model getValueWithItem:midStr viewsFrameDicM:viewsFrameDicM];
                    if (result.length>0) {
//                        NSLog(@"%@=%@",midStr,result);
                        foundCount++;
                        [codeText setString:[codeText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<#%@#>",midStr] withString:result]];
                        break;//默认取第一个
                    }
                }
            }
        }
        
        if (foundCount==0) {
            NSString *viewFrame_self=viewsFrameDicM[viewName];
            NSArray *frames_self=[viewFrame_self componentsSeparatedByString:@","];
            NSString *x_self=@"",*y_self=@"",*w_self=@"",*h_self=@"";
            if(frames_self.count>0)x_self=frames_self[0];
            if(frames_self.count>1)y_self=frames_self[1];
            if(frames_self.count>2)w_self=frames_self[2];
            if(frames_self.count>3)h_self=frames_self[3];
            if ([midStr hasSuffix:@".X"]) {
                [codeText setString:[codeText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<#%@#>",midStr] withString:[NSString stringWithFormat:@"%@.superview.width-(%@)",viewName,w_self]]];
            }else if([midStr hasSuffix:@".Y"]) {
                [codeText setString:[codeText stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<#%@#>",midStr] withString:[NSString stringWithFormat:@"%@.superview.height-(%@)",viewName,h_self]]];
            }
        }
    }
    
    return nil;
}

@end
