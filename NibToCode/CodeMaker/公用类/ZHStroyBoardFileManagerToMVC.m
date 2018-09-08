#import "ZHStroyBoardFileManagerToMVC.h"

@implementation ZHStroyBoardFileManagerToMVC
+ (void)creatOriginalTableViewCell_m:(NSString *)name forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"\n@end\n",[NSString stringWithFormat:@"@implementation %@",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (void)awakeFromNib {\n\
                                   [super awakeFromNib];\n\
                                   }\n\
                                   \n\
                                   - (void)setSelected:(BOOL)selected animated:(BOOL)animated {\n\
                                   [super setSelected:selected animated:animated];\n\
                                   }\n\
                                   \n\
                                   @end"] ToStrM:text];
    [self creatFileWithViewController:viewController name:name text:text isM:YES isModel:NO isView:YES isController:NO];
}
+ (void)creatOriginalViewController_m:(NSString *)name isTableView:(BOOL)isTableView isCollectionView:(BOOL)isCollectionView forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"\n@end\n",[NSString stringWithFormat:@"@implementation %@\n",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (void)viewDidLoad{\n\
                                   [super viewDidLoad];\n\
                                   }\n\
                                   \n\
                                   - (void)didReceiveMemoryWarning {\n\
                                   [super didReceiveMemoryWarning];\n\
                                   }\n\
                                   @end"] ToStrM:text];
    [self creatFileWithViewController:viewController name:name text:text isM:YES isModel:NO isView:NO isController:YES];
}
+ (void)creatOriginalCollectionViewCell_m:(NSString *)name forViewController:(NSString *)viewController{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"\n@end\n",[NSString stringWithFormat:@"@implementation %@\n",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (void)awakeFromNib {\n\
                                   [super awakeFromNib];\n\
                                   }\n\
                                   \n\
                                   - (void)setSelected:(BOOL)selected{\n\
                                   [super setSelected:selected];\n\
                                   }\n",@"@end"] ToStrM:text];
    [self creatFileWithViewController:viewController name:name text:text isM:YES isModel:NO isView:YES isController:NO];
}
+ (void)creatOriginalView_m:(NSString *)name forView:(NSString *)view{
    NSMutableString *text=[NSMutableString string];
    [self insertValueAndNewlines:@[[NSString stringWithFormat:@"#import \"%@.h\"\n",name],[NSString stringWithFormat:@"@interface %@ ()\n",name],@"\n@end\n",[NSString stringWithFormat:@"@implementation %@\n",name]] ToStrM:text];
    [self insertValueAndNewlines:@[@"- (void)awakeFromNib {\n\
                                   [super awakeFromNib];\n\
                                   }\n",@"@end"] ToStrM:text];
    [self creatFileWithViewController_XIB:view name:name text:text isM:YES isModel:NO isView:YES isController:NO];
}
@end
