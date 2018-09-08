//
//  ViewController.m
//  NibToCode
//
//  Created by dfpo on 2017/6/10.
//  Copyright © 2017年 dfpo. All rights reserved.
//

#import "ViewController.h"
#import "XMDragView.h"
#import "XMFileItem.h"
#import "ZHStoryboardManager.h"
#import "ZHStroyBoardToPureHandMVC.h"
#import "ZHStroyBoardToFrameMVC.h"
@interface ViewController()<XMDragViewDelegate>

/**
 *  在拖新文件进来时是否需要清空现在列表
 */
@property (nonatomic, assign) BOOL needClearDragList;
/**
 *  拖进来的文件（夹）
 */
@property (nonatomic, strong) NSMutableArray<XMFileItem *> *dragFileList;

/**
 *  支持处理的类型，目前仅支持png、jpg、ipa、car文件
 */
@property (nonatomic, copy) NSArray *extensionList;

@property (weak) IBOutlet NSMatrix *chooseTypeControl;
@property(nonatomic) GetSBViewControllerType getSBViewControllerType;

@property (weak) IBOutlet NSTextField *filed;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.needClearDragList = YES;
    // 支持的扩展名文件
    self.extensionList = @[@"storyboard", @"xib"];

    self.getSBViewControllerType = GetSBViewControllerTypeFrame;

}
#pragma mark - XMDragViewDelegate

/**
 *  处理拖拽文件代理
 */
- (void)dragView:(XMDragView *)dragView didDragItems:(NSArray *)items
{
    [self addPathsWithArray:items];
}
#pragma mark - actoin
- (IBAction)takeStyleFrom:(NSMatrix *)sender
{
    NSInteger tag = [[sender selectedCell] tag];
    if (tag == 2) {
        
        self.getSBViewControllerType = GetSBViewControllerTypeFrame;
        self.filed.stringValue = @"托入Storyboard或者xib即可";

    } else {
        
        self.getSBViewControllerType = GetSBViewControllerTypePureHand;
        self.filed.stringValue = @"托入Storyboard或者xib即可";
    }
}
#pragma mark - other
/**
 *  添加拖拽进来的文件
 */
- (void)addPathsWithArray:(NSArray*)path
{
    
    if (self.needClearDragList) {
        [self.dragFileList removeAllObjects];
        self.needClearDragList = NO;
    }
    
    for (NSString *addItem in path) {
        
        XMFileItem *fileItem = [XMFileItem xmFileItemWithPath:addItem];
        
        // 过滤不支持的文件格式
        if (!fileItem.isDirectory) {
            BOOL isExpectExtension = NO;
            NSString *pathExtension = [addItem pathExtension];
            for (NSString *item in self.extensionList) {
                if ([item isEqualToString:pathExtension]) {
                    isExpectExtension = YES;
                    break;
                }
            }
            
            if (!isExpectExtension) {
                continue;
            }
        }
        
        // 过滤已经存在的路径
        BOOL isExist = NO;
        for (XMFileItem *dataItem in self.dragFileList) {
            if ([dataItem.filePath isEqualToString:addItem]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [self.dragFileList removeAllObjects];
            [self.dragFileList addObject:fileItem];
        }
    }
    
    if (self.dragFileList.count > 0) {
        for (int i = 0; i < self.dragFileList.count; ++i) {
            
            [self creatCodeWithFile:self.dragFileList[i]];
        }
    }
    else {
//        [self setStatusString:@""];
    }
    
}
#pragma mark - key method
- (void)creatCodeWithFile:(XMFileItem *)file {
    
    NSString *filePath = file.filePath;
    NSString *fileExtension = [[self.dragFileList[0] filePath] pathExtension];
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在生成代码!";
    hud.graceTime = 2;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 处理耗时操作的代码块...
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]==NO) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.labelText =@"路径不存在";
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
            return ;
        }
        
        if (self.getSBViewControllerType ==GetSBViewControllerTypePureHand) {
            
            if ([fileExtension isEqualToString:self.extensionList[0]]) {
                
                [[ZHStroyBoardToPureHandMVC new] StroyBoard_To_PureHand_MVC:filePath];
            } else if ([fileExtension isEqualToString:self.extensionList[1]]) {
                
                [[ZHStoryboardManager new] Xib_To_Masonry:filePath];
            }
            
        } else if (self.getSBViewControllerType == GetSBViewControllerTypeFrame) {
            
            if ([fileExtension isEqualToString:self.extensionList[0]]) {
                
                [[ZHStroyBoardToFrameMVC new] StroyBoard_To_Frame_MVC:filePath];
            } else if ([fileExtension isEqualToString:self.extensionList[1]]) {

                [[ZHStroyBoardToFrameMVC new] Xib_To_Frame:filePath];
            }
            
        }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.labelText=@"生成成功";
            hud.graceTime = 2;
            //回调或者说是通知主线程刷新，
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hud.graceTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:[self desktopFolder]];
                
            });
        });
        
    });
}
- (NSString*) desktopFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    
    // 获得当前文件夹path下面的所有内容（文件夹、文件）
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:basePath error:nil];
    __block BOOL hasFolder = NO;
    __block NSString *folderPath = @"";
    __block NSMutableArray<NSString *> *foldersPaths = @[].mutableCopy;
    array = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *file1Path, NSString *file2Path) {
        
        // compare
        NSDate *file1Date =
        [[NSFileManager defaultManager] attributesOfItemAtPath:file1Path error:nil][@"NSFileCreationDate"];
        NSDate *file2Date =
        [[NSFileManager defaultManager] attributesOfItemAtPath:file2Path error:nil][@"NSFileCreationDate"];
        // Ascending:
        return [file1Date compare: file2Date];
    }];
    
    // 遍历数组中的所有子文件（夹）名
    [array enumerateObjectsUsingBlock:^(NSString  *_Nonnull filename, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", basePath, filename];
        if ([self isDirAtPath:fullPath] && [filename hasSuffix:@"秒代码生成"]) {
            hasFolder = YES;
            folderPath = fullPath;
            [foldersPaths addObject:fullPath];
        }
        
    }];
    if (hasFolder) {
        
        [foldersPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull folderPath, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"----%@---", [[NSFileManager defaultManager] attributesOfItemAtPath:folderPath error:nil][@"NSFileCreationDate"]);
        }];
        return folderPath;
    }
    return basePath;
}
- (BOOL)isDirAtPath:(NSString *)path {
    /// 是否为文件夹
    BOOL dir = NO;
    
    /// 路径是否存在
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir];
    if(!exist)
    {
        NSLog(@"%@,文件路径不存在!!!!!!", path);

    }

    return dir;
}

#pragma mark - getter and setter
- (NSMutableArray<XMFileItem *> *)dragFileList
{
    if (_dragFileList == nil) {
        _dragFileList = [NSMutableArray array];
    }
    
    return _dragFileList;
}

@end
