#import "ZHStroyBoardToFrameModel.h"

@implementation ZHStroyBoardToFrameModel
- (NSString *)getValueWithItem:(NSString *)item viewsFrameDicM:(NSMutableDictionary *)viewsFrameDicM{
    BOOL is_X=NO;
    if ([item hasSuffix:@".X"]){is_X=YES;item=[item stringByReplacingOccurrencesOfString:@".X" withString:@""];}
    else if([item hasSuffix:@".Y"]){is_X=NO;item=[item stringByReplacingOccurrencesOfString:@".Y" withString:@""];}
    
    NSMutableString *tempStrM=[NSMutableString string];
    if ([item isEqualToString:self.firstItem]) {
        
        NSString *viewFrame_self=viewsFrameDicM[self.firstItem];
        NSArray *frames_self=[viewFrame_self componentsSeparatedByString:@","];
        NSString *x_self=@"",*y_self=@"",*w_self=@"",*h_self=@"";
        if(frames_self.count>0)x_self=frames_self[0];
        if(frames_self.count>1)y_self=frames_self[1];
        if(frames_self.count>2)w_self=frames_self[2];
        if(frames_self.count>3)h_self=frames_self[3];
        
        NSString *viewFrame_other=viewsFrameDicM[self.secondItem];
        NSArray *frames_other=[viewFrame_other componentsSeparatedByString:@","];
        NSString *x_other=@"",*y_other=@"",*w_other=@"",*h_other=@"";
        if(frames_other.count>0)x_other=frames_other[0];
        if(frames_other.count>1)y_other=frames_other[1];
        if(frames_other.count>2)w_other=frames_other[2];
        if(frames_other.count>3)h_other=frames_other[3];
        
        if (self.isChild) {
            if (is_X) {
                if([self.firstAttribute isEqualToString:@"leading"]){
                    if ([self.secondAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: @"0"];
                    }else if ([self.secondAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: @""];
                    }
                }
                if([self.firstAttribute isEqualToString:@"centerX"]){
                    if ([self.secondAttribute isEqualToString:@"centerX"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.width-%@)/2.0",self.secondItem,w_self]];
                    }
                }
                if([self.firstAttribute isEqualToString:@"trailing"]){
                    if ([self.secondAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: @""];
                    }else if ([self.secondAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.width-%@",self.secondItem,w_self]];
                    }
                }
            }else{
                if([self.firstAttribute isEqualToString:@"bottom"]){
                    if ([self.secondAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.height-%@",self.secondItem,h_self]];
                    }else if ([self.secondAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.height-%@",self.secondItem,h_self]];
                    }
                }
                if([self.firstAttribute isEqualToString:@"top"]){
                    if ([self.secondAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: @"0"];
                    }else if ([self.secondAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: @""];
                    }
                }
                if([self.firstAttribute isEqualToString:@"centerY"]){
                    if ([self.secondAttribute isEqualToString:@"centerY"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.height-%@)/2.0",self.secondItem,h_self]];
                    }
                }
            }
        }
        else{
            if (is_X) {
                if([self.firstAttribute isEqualToString:@"leading"]){
                    if ([self.secondAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.x",self.secondItem]];
                    }else if ([self.secondAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.x+%@.width",self.secondItem,self.secondItem]];
                    }
                }
                if([self.firstAttribute isEqualToString:@"centerX"]){
                    if ([self.secondAttribute isEqualToString:@"centerX"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"((%@.x+%@.width)/2.0)-%@",self.secondItem,self.secondItem,w_self]];
                    }
                }
                if([self.firstAttribute isEqualToString:@"trailing"]){
                    if ([self.secondAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.x-%@",self.secondItem,w_self]];
                    }else if ([self.secondAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.x+%@.width)-%@",self.secondItem,self.secondItem,w_self]];
                    }
                }
            }else{
                if([self.firstAttribute isEqualToString:@"bottom"]){
                    if ([self.secondAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.y-%@",self.secondItem,h_self]];
                    }else if ([self.secondAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.y+%@.height)-%@",self.secondItem,self.secondItem,h_self]];
                    }
                }
                if([self.firstAttribute isEqualToString:@"top"]){
                    if ([self.secondAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.y",self.secondItem]];
                    }else if ([self.secondAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.y+%@.height",self.secondItem,self.secondItem]];
                    }
                }
                if([self.firstAttribute isEqualToString:@"centerY"]){
                    if ([self.secondAttribute isEqualToString:@"centerY"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"((%@.y+%@.height)/2.0)-%@",self.secondItem,self.secondItem,h_self]];
                    }
                }
            }
        }
    }
    else if ([item isEqualToString:self.secondItem]) {
        
        NSString *viewFrame_self=viewsFrameDicM[self.secondItem];
        NSArray *frames_self=[viewFrame_self componentsSeparatedByString:@","];
        NSString *x_self=@"",*y_self=@"",*w_self=@"",*h_self=@"";
        if(frames_self.count>0)x_self=frames_self[0];
        if(frames_self.count>1)y_self=frames_self[1];
        if(frames_self.count>2)w_self=frames_self[2];
        if(frames_self.count>3)h_self=frames_self[3];
        
        NSString *viewFrame_other=viewsFrameDicM[self.firstItem];
        NSArray *frames_other=[viewFrame_other componentsSeparatedByString:@","];
        NSString *x_other=@"",*y_other=@"",*w_other=@"",*h_other=@"";
        if(frames_other.count>0)x_other=frames_other[0];
        if(frames_other.count>1)y_other=frames_other[1];
        if(frames_other.count>2)w_other=frames_other[2];
        if(frames_other.count>3)h_other=frames_other[3];
        
        if (self.isChild) {
            
            //父view不应该参照子view
            return @"";
            
            if (is_X) {
                if([self.secondAttribute isEqualToString:@"leading"]){
                    if ([self.firstAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: @"0"];
                    }else if ([self.firstAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: @""];
                    }
                }
                if([self.secondAttribute isEqualToString:@"centerX"]){
                    if ([self.firstAttribute isEqualToString:@"centerX"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.width-%@)/2.0",self.firstItem,w_self]];
                    }
                }
                if([self.secondAttribute isEqualToString:@"trailing"]){
                    if ([self.firstAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: @""];
                    }else if ([self.firstAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.width-%@",self.firstItem,w_self]];
                    }
                }
            }else{
                if([self.secondAttribute isEqualToString:@"bottom"]){
                    if ([self.firstAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.height-%@",self.firstItem,h_self]];
                    }else if ([self.firstAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.height-%@",self.firstItem,h_self]];
                    }
                }
                if([self.secondAttribute isEqualToString:@"top"]){
                    if ([self.firstAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: @"0"];
                    }else if ([self.firstAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: @""];
                    }
                }
                if([self.secondAttribute isEqualToString:@"centerY"]){
                    if ([self.firstAttribute isEqualToString:@"centerY"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.height-%@)/2.0",self.firstItem,h_self]];
                    }
                }
            }
        }
        else{
            if (is_X) {
                if([self.secondAttribute isEqualToString:@"leading"]){
                    if ([self.firstAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.x",self.firstItem]];
                    }else if ([self.firstAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.x+%@.width",self.firstItem,self.firstItem]];
                    }
                }
                if([self.secondAttribute isEqualToString:@"centerX"]){
                    if ([self.firstAttribute isEqualToString:@"centerX"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"((%@.x+%@.width)/2.0)-%@",self.firstItem,self.firstItem,w_self]];
                    }
                }
                if([self.secondAttribute isEqualToString:@"trailing"]){
                    if ([self.firstAttribute isEqualToString:@"leading"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.x-%@",self.firstItem,w_self]];
                    }else if ([self.firstAttribute isEqualToString:@"trailing"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.x+%@.width)-%@",self.firstItem,self.firstItem,w_self]];
                    }
                }
            }else{
                if([self.secondAttribute isEqualToString:@"bottom"]){
                    if ([self.firstAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.y-%@",self.firstItem,h_self]];
                    }else if ([self.firstAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"(%@.y+%@.height)-%@",self.firstItem,self.firstItem,h_self]];
                    }
                }
                if([self.secondAttribute isEqualToString:@"top"]){
                    if ([self.firstAttribute isEqualToString:@"top"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.y",self.firstItem]];
                    }else if ([self.firstAttribute isEqualToString:@"bottom"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"%@.y+%@.height",self.firstItem,self.firstItem]];
                    }
                }
                if([self.secondAttribute isEqualToString:@"centerY"]){
                    if ([self.firstAttribute isEqualToString:@"centerY"]) {
                        [tempStrM setString: [NSString stringWithFormat:@"((%@.y+%@.height)/2.0)-%@",self.firstItem,self.firstItem,h_self]];
                    }
                }
            }
        }
    }
    if (tempStrM.length<=0) {
        return @"";
    }
    if (self.constant.length>0) [tempStrM setString:[tempStrM stringByAppendingString:self.constant]];
    if (self.multiplier.length>0) [tempStrM setString:[NSString stringWithFormat:@"(%@)*%@",tempStrM,self.multiplier]];
    return tempStrM;
}
@end
