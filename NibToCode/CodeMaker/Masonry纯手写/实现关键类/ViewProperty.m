#import "ViewProperty.h"

@implementation ViewProperty
- (BOOL)hasProperty:(NSString *)property{
    NSString *propertys=@"_reuseIdentifier_placeholder_on_clearButtonMode_image_pointSize_alpha_contentMode_style_adjustsFontSizeToFit_text_textAlignment_rowHeight_title_type_backgroundImage_selector_eventType_segment_numberOfLines_";
    
    if ([propertys rangeOfString:[NSString stringWithFormat:@"_%@_",property]].location!=NSNotFound) {
        return YES;
    }
    return NO;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"Property不存在这个属性%@",key);
}
- (NSString *)rect_x{
    if (!_rect_x) {
        return @"0";
    }
    return _rect_x;
}
- (NSString *)rect_y{
    if (!_rect_y) {
        return @"0";
    }
    return _rect_y;
}
- (NSString *)rect_w{
    if (!_rect_w) {
        return @"0";
    }
    return _rect_w;
}
- (NSString *)rect_h{
    if (!_rect_h) {
        return @"0";
    }
    return _rect_h;
}
@end
