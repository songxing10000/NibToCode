#import "ZHStroyBoardToPureHandMVC.h"
#import "ZHStoryboardTextManagerToHandPureMVC.h"

@interface ZHStroyBoardToPureHandMVC ()
@property (nonatomic,strong)NSDictionary *customAndId;
@property (nonatomic,strong)NSDictionary *customAndName;
@property (nonatomic,strong)NSDictionary *idAndViewPropertys;
@property (nonatomic,strong)NSDictionary *idAndOutletViews;
@property (nonatomic,strong)NSDictionary *idAndViews;
@end
@implementation ZHStroyBoardToPureHandMVC
- (NSString *)StroyBoard_To_PureHand_MVC:(NSString *)stroyBoard{
    NSString *filePath=stroyBoard;
    
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        return @"";
    }
    /// 从storyboard获取到的XML字符串
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[ZHStoryboardTextManagerToHandPureMVC addCustomClassToAllViews:context];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    NSArray *allViewControllers=[ZHStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
    
    //    获取所有的ViewController名字
    NSArray *viewControllers=[ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViewControllers];
    
    for (NSString *viewController in viewControllers) {
        //创建MVC文件夹
        [ZHStroyBoardFileManager creat_MVC_WithViewControllerName:viewController];
        //创建对应的ViewController文件
        [ZHStroyBoardFileManager creat_m_h_file:viewController isModel:NO isView:NO isController:YES isTableView:YES isCollectionView:NO forViewController:viewController];
    }
    
    //获取所有View的CustomClass与对应的id
    NSDictionary *customAndId=[ZHStoryboardXMLManager getAllViewCustomAndIdWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndId=customAndId;
    //获取所有View的CustomClass与对应的真实控件类型名字
    NSDictionary *customAndName=[ZHStoryboardXMLManager getAllViewCustomAndNameWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.customAndName=customAndName;
    
    NSDictionary *idAndViews=[ZHStoryboardXMLManager getAllViewWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.idAndViews=idAndViews;
    
    NSDictionary *idAndViewPropertys=[ZHStoryboardPropertyManager getPropertysForView:idAndViews withCustomAndName:customAndName andXMLHandel:xml];
    self.idAndViewPropertys=idAndViewPropertys;
    
    NSDictionary *idAndOutletViews=[ZHStoryboardXMLManager getAllOutletViewWithAllViewControllerArrM:allViewControllers andXMLHandel:xml];
    self.idAndOutletViews=idAndOutletViews;
    
    //开始操作所有ViewController
    for (NSDictionary *dic in allViewControllers) {
        
        NSString *viewController;
        if(dic[@"customClass"]!=nil){
            viewController=dic[@"customClass"];
            {
                NSString *viewControllerFileName=[viewController stringByAppendingString:viewController];//对应的ViewController字典key值,通过这个key值可以找到对应存放在字典中的文件内容
                
                //先创建所有cell文件
                NSArray *allTableViewCells=[ZHStoryboardXMLManager getAllTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *tableViewCell in allTableViewCells) {
                    
                    //创建对应的CellView文件
                    [ZHStroyBoardFileManager creat_m_h_file:tableViewCell isModel:NO isView:YES isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                    //创建对应的Model文件
                    [ZHStroyBoardFileManager creat_m_h_file:tableViewCell isModel:YES isView:NO isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                }
                
                NSArray *allCollectionViewCells=[ZHStoryboardXMLManager getAllCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *collectionViewCell in allCollectionViewCells) {
                    //创建对应的CellView文件
                    [ZHStroyBoardFileManager creat_m_h_file:collectionViewCell isModel:NO isView:YES isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
                    //创建对应的Model文件
                    [ZHStroyBoardFileManager creat_m_h_file:collectionViewCell isModel:YES isView:NO isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
                }
                
                //获取这个ViewController的所有tableView ,其中每个tableView都对应其所有的tableViewCell
                NSDictionary *tableViewCellDic=[ZHStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                
                NSMutableArray *tableViewCells=[NSMutableArray array];
                for (NSString *tableView in tableViewCellDic) {
                    NSArray *cells=tableViewCellDic[tableView];
                    for (NSString *cell in cells) {
                        if ([tableViewCells containsObject:cell]==NO) {
                            [tableViewCells addObject:cell];
                        }
                    }
                }
                
                //获取这个ViewController的所有collectionView ,其中每个collectionView都对应其所有的collectionViewCell
                NSDictionary *collectionViewCellDic=[ZHStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                
                NSMutableArray *collectionViewCells=[NSMutableArray array];
                for (NSString *collectionView in collectionViewCellDic) {
                    NSArray *cells=collectionViewCellDic[collectionView];
                    for (NSString *cell in cells) {
                        if ([collectionViewCells containsObject:cell]==NO) {
                            [collectionViewCells addObject:cell];
                        }
                    }
                }
                
                //插入#import
                for (NSString *tableViewCell in tableViewCells) {
                    [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                for (NSString *collectionViewCell in collectionViewCells) {
                    [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                //插入属性property
                NSArray *views=[ZHStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
                NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
                NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
                
                //获取特殊的View --- >self.view
                [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:@"self.view" withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                
                for (NSString *idStr in views) {
                    
                    //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
                    [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:dic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
                    
                    //这里获取的属性不包括特殊控件,比如tableView,collectionView
                    NSString *property=@"";
                    if (self.idAndOutletViews[idStr]!=nil) {
                        property=[ZHStoryboardTextManagerToHandPureMVC getPropertyWithViewName:self.idAndOutletViews[idStr] withViewCategory:customAndName[idStr]];
                    }else{
                        property=[ZHStoryboardTextManagerToHandPureMVC getPropertyWithViewName:customAndId[idStr] withViewCategory:customAndName[idStr]];
                    }
                    
                    if (property.length>0) {
                        [ZHStoryboardTextManagerToHandPureMVC addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
                NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
                NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
                
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
                
                //在这里插入所有view的创建和约束
                
                //开始建立一个父子和兄弟关系的链表
                NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
                [ZHStoryboardXMLManager createRelationShipWithControllerDic:dic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:NO];
                
                
                //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止又一次创建
                NSMutableArray *brotherOrderArrM=[NSMutableArray array];
                
                BOOL isOnlyTableViewOrCollectionView=NO;
                if(tableViewCellDic.count>0||collectionViewCellDic.count>0){
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    if (tableViewCount>0&&collectionViewCount>0) {
                        isOnlyTableViewOrCollectionView=NO;
                    }else if(tableViewCount<=1&&collectionViewCount<=1){
                        isOnlyTableViewOrCollectionView=YES;
                    }else{
                        isOnlyTableViewOrCollectionView=NO;
                    }
                }
                
                //1.首先开始创建控件  从父亲的subViews开始
                NSMutableString *creatCodeStrM=[NSMutableString string];
                [creatCodeStrM appendString:@"- (void)addSubViews{\n\n"];
                for (NSString *idStr in views) {
                    NSString *fatherView=[ZHStoryboardTextManagerToHandPureMVC getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
                    
                    NSString *creatCode=[ZHStoryboardTextManagerToHandPureMVC getCreateViewCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr]  withOutletView:nil addToFatherView:fatherView withDoneArrM:brotherOrderArrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:self.idAndOutletViews];
                    
                    NSMutableString *propertyCode=[NSMutableString string];
                    [propertyCode setString:creatCode];
                    
                    [ZHStoryboardPropertyManager getCodePropertysForViewName:idStr WithidAndViewDic:customAndId withCustomAndName:customAndName withProperty:idAndViewPropertys[idStr] toCodeText:propertyCode];
                    
                    [creatCodeStrM appendString:propertyCode];
                    
                    NSString *selectorEventType=[ZHStoryboardPropertyManager getSelectorEventTypeForViewName:idStr withProperty:idAndViewPropertys[idStr]];
                    if (selectorEventType.length>0) {
                        [ZHStoryboardTextManagerToHandPureMVC addCodeText:selectorEventType andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                    
                    NSMutableDictionary *originalConstraintDicM_Self=[NSMutableDictionary dictionary];
                    [ZHStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
                    
                    //创建约束
                    NSString *constraintCode=[ZHStoryboardTextManagerToHandPureMVC getCreatConstraintCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW withSelfConstraintDic:originalConstraintDicM_Self withOutletView:nil isCell:NO withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:self.idAndOutletViews];
                    
                    //有时我们在StroyBoard或者xib中忘记添加约束,这是就用默认的frame作为约束
                    if([constraintCode rangeOfString:@".equalTo"].location==NSNotFound&&[constraintCode rangeOfString:@"make."].location==NSNotFound){
                        
                        NSString *constraintCodeDefualt=[ZHStoryboardPropertyManager getConstraintIfNotGiveConstraintsForViewName:idStr withProperty:self.idAndViewPropertys[idStr] withFatherView:fatherView];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",idStr] withString:@""];
                        constraintCode = [constraintCode stringByReplacingOccurrencesOfString:@"}];\n\n\n" withString:@""];
                        constraintCode = [constraintCode stringByAppendingString:constraintCodeDefualt];
                        constraintCode = [constraintCode stringByAppendingString:@"\n\n"];
                        
                    }
                    
                    [creatCodeStrM appendString:constraintCode];
                }
                
                //解决self.tableView3=tableView3;的问题 但是实际上这个viewcontroller只有一个tableView
                [ZHStoryboardTextManagerToHandPureMVC dealWith_self_tableView_collectionView:creatCodeStrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
                
                [creatCodeStrM appendString:@"}\n"];
                
                [ZHStoryboardTextManagerToHandPureMVC addCodeText:creatCodeStrM andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                
                //解决UIMapView *mapView1;的问题
                [ZHStoryboardTextManagerToHandPureMVC dealWith_UIMapView:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] needInserFramework:YES];
                
                //再添加代码
                if(tableViewCellDic.count>0&&collectionViewCellDic.count>0){
                    
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"1-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"2-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    //添加代理方法
                    [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                    [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                }
                else if (tableViewCellDic.count>0){
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"3-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    if (tableViewCount==1) {
                        //添加代理方法
                        [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
                    }else{
                        //添加代理方法
                        [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                    }
                    
                }
                else if (collectionViewCellDic.count>0){
                    
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"4-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    if (collectionViewCount==1) {
                        //添加代理方法
                        [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
                    }else{
                        //添加代理方法
                        [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                    }
                }
            }
            
            NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            
            [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
            [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        }
    }
    
    NSString *mainPath=[ZHStroyBoardFileManager getMainDirectory];
    
    NSInteger count=0;
    
    count=[ZHStoryboardTextManagerToHandPureMVC getAllViewCount];
    
    //这句话一定要加
    [ZHStroyBoardFileManager done];
    [ZHStoryboardTextManagerToHandPureMVC done];
    
    customAndId=nil;
    customAndName=nil;
    xml=nil;
    return mainPath;
}

/**递归继续子cell的代码生成*/
- (void)detailSubCells:(NSArray *)subCells andXMLHandel:(ReadXML *)xml withFatherViewController:(NSString *)viewController{
    for (NSDictionary *subDic in subCells) {
        
        NSString *fatherCellName=[xml dicNodeValueWithKey:@"customClass" ForDic:subDic];
        NSString *NewFileName=[viewController stringByAppendingString:fatherCellName];
        
        //给.h文件添加refreshUI的方法
        //先导入model头文件
        [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        //再添加refreshUI方法
        [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"- (void)refreshUI:(%@ *)dataModel;",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //给.m文件添加model弱引用
        [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"@property (weak, nonatomic) %@ *dataModel;//model弱引用\n",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //给.m文件添加refreshUI
        [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"\n- (void)refreshUI:(%@ *)dataModel{\n_dataModel=dataModel;\n\
                                                   \n\
                                                   }",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        
        NSDictionary *subTableViewCells=[ZHStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subTableViewCells.count>0) {
            //插入#import
            for (NSString *tableViewName in subTableViewCells) {
                NSArray *tableViewCells=subTableViewCells[tableViewName];
                for (NSString *tableViewCell in tableViewCells) {
                    [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        NSDictionary *subCollectionViewCells=[ZHStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subCollectionViewCells.count>0) {
            for (NSString *collectionViewName in subCollectionViewCells) {
                NSArray *collectionViewCells=subCollectionViewCells[collectionViewName];
                for (NSString *collectionViewCell in collectionViewCells) {
                    [ZHStoryboardTextManagerToHandPureMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        //插入属性property
        NSArray *views=[ZHStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:subDic andXMLHandel:xml];
        
        //在这里,定义存储控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束的字典
        NSMutableDictionary *viewConstraintDicM_Self=[NSMutableDictionary dictionary];
        NSMutableDictionary *viewConstraintDicM_Other=[NSMutableDictionary dictionary];
        
        //获取特殊的View --- >self.view
        [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:fatherCellName withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
        
        
        for (NSString *idStr in views) {
            
            //在这里,获取控件自身的所有约束 比如宽度和高度之类 和关联对象的所有约束
            [ZHStoryboardXMLManager getViewAllConstraintWithControllerDic:subDic andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:viewConstraintDicM_Self withOtherConstraintDicM:viewConstraintDicM_Other];
            
            //这里获取的属性不包括特殊控件,比如tableView,collectionView
            NSString *property=@"";
            if (self.idAndOutletViews[idStr]!=nil) {
                property=[ZHStoryboardTextManagerToHandPureMVC getPropertyWithViewName:self.idAndOutletViews[idStr] withViewCategory:self.customAndName[idStr]];
            }else{
                property=[ZHStoryboardTextManagerToHandPureMVC getPropertyWithViewName:self.customAndId[idStr] withViewCategory:self.customAndName[idStr]];
            }
            if (property.length>0) {
                [ZHStoryboardTextManagerToHandPureMVC addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
            }
        }
        
        NSMutableDictionary *viewConstraintDicM_Self_NEW=[viewConstraintDicM_Self mutableCopy];
        NSMutableDictionary *viewConstraintDicM_Other_NEW=[viewConstraintDicM_Other mutableCopy];
        
        
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Second:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        [ZHStoryboardXMLManager reAdjustViewAllConstraintWithNewSelfConstraintDicM_Three:viewConstraintDicM_Self_NEW withNewOtherConstraintDicM:viewConstraintDicM_Other_NEW withXMLHandel:xml];
        
        //在这里插入所有view的创建和约束
        
        //开始建立一个父子和兄弟关系的链表
        NSMutableDictionary *viewRelationShipDic=[NSMutableDictionary dictionary];
        [ZHStoryboardXMLManager createRelationShipWithControllerDic:subDic andXMLHandel:xml WithViews:[NSMutableArray arrayWithArray:views] withRelationShipDic:viewRelationShipDic isCell:YES];
        
        
        BOOL isOnlyTableViewOrCollectionView=YES;
        if(subTableViewCells.count>0||subCollectionViewCells.count>0){
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            if (tableViewCount>0&&collectionViewCount>0) {
                isOnlyTableViewOrCollectionView=NO;
            }else if(tableViewCount<=1&&collectionViewCount<=1){
                isOnlyTableViewOrCollectionView=YES;
            }else{
                isOnlyTableViewOrCollectionView=NO;
            }
        }
        
        //创建这个数组是无奈之举,因为兄弟之间的约束,有时候是两个兄弟之间的互相约束,这样必须先同时创建两个兄弟,所以才用这个数组来保存已经创建好的兄弟,防止有一次创建
        NSMutableArray *brotherOrderArrM=[NSMutableArray array];
        
        //1.首先开始创建控件  从父亲的subViews开始
        NSMutableString *creatCodeStrM=[NSMutableString string];
        [creatCodeStrM appendString:@"- (void)addSubViews{\n\n"];
        for (NSString *idStr in views) {
            NSString *fatherView=[ZHStoryboardTextManagerToHandPureMVC getFatherView:self.customAndId[idStr] inViewRelationShipDic:viewRelationShipDic];
            
            NSString *creatCode=[ZHStoryboardTextManagerToHandPureMVC getCreateViewCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withViewCategoryName:self.customAndName[idStr] withOutletView:nil addToFatherView:fatherView withDoneArrM:brotherOrderArrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:self.idAndOutletViews];
            
            NSMutableString *propertyCode=[NSMutableString string];
            [propertyCode setString:creatCode];
            
            [ZHStoryboardPropertyManager getCodePropertysForViewName:idStr WithidAndViewDic:self.customAndId withCustomAndName:self.customAndName withProperty:self.idAndViewPropertys[idStr] toCodeText:propertyCode];
            
            [creatCodeStrM appendString:propertyCode];
            
            NSString *selectorEventType=[ZHStoryboardPropertyManager getSelectorEventTypeForViewName:idStr withProperty:self.idAndViewPropertys[idStr]];
            if (selectorEventType.length>0) {
                [ZHStoryboardTextManagerToHandPureMVC addCodeText:selectorEventType andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
            }
            
            NSMutableDictionary *originalConstraintDicM_Self=[NSMutableDictionary dictionary];
            [ZHStoryboardXMLManager getViewAllConstraintWithViewDic:self.idAndViews[idStr] andXMLHandel:xml withViewIdStr:idStr withSelfConstraintDicM:originalConstraintDicM_Self];
            
            //创建约束
            NSString *constraintCode=[ZHStoryboardTextManagerToHandPureMVC getCreatConstraintCodeWithIdStr:idStr WithViewName:self.customAndId[idStr] withConstraintDic:viewConstraintDicM_Self_NEW withSelfConstraintDic:originalConstraintDicM_Self withOutletView:nil isCell:YES withDoneArrM:brotherOrderArrM withCustomAndNameDic:self.customAndName addToFatherView:fatherView isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:self.idAndOutletViews];
            
            //有时我们在StroyBoard或者xib中忘记添加约束,这是就用默认的frame作为约束
            if([constraintCode rangeOfString:@".equalTo"].location==NSNotFound&&[constraintCode rangeOfString:@"make."].location==NSNotFound){
                
                NSString *constraintCodeDefualt=[ZHStoryboardPropertyManager getConstraintIfNotGiveConstraintsForViewName:idStr withProperty:self.idAndViewPropertys[idStr] withFatherView:fatherView];
                constraintCode = [constraintCode stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"[%@ mas_makeConstraints:^(MASConstraintMaker *make) {\n",idStr] withString:@""];
                constraintCode = [constraintCode stringByReplacingOccurrencesOfString:@"}];\n\n\n" withString:@""];
                constraintCode = [constraintCode stringByAppendingString:constraintCodeDefualt];
                constraintCode = [constraintCode stringByAppendingString:@"\n\n"];
            }
            
            [creatCodeStrM appendString:constraintCode];
        }
        
        //解决self.tableView3=tableView3;的问题
        [ZHStoryboardTextManagerToHandPureMVC dealWith_self_tableView_collectionView:creatCodeStrM isOnlyTableViewOrCollectionView:isOnlyTableViewOrCollectionView];
        
        [creatCodeStrM appendString:@"}"];
        [ZHStoryboardTextManagerToHandPureMVC addCodeText:creatCodeStrM andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //解决UIMapView *mapView1;的问题
        [ZHStoryboardTextManagerToHandPureMVC dealWith_UIMapView:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] needInserFramework:YES];
        
        
        //再添加代码
        if(subTableViewCells.count>0&&subCollectionViewCells.count>0){
            
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger tableViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            //添加代理方法
            [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
            [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
        }
        else if (subTableViewCells.count>0){
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            
            NSInteger tableViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (tableViewCount==1) {
                //添加代理方法
                [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
            }else{
                //添加代理方法
                [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
            }
            
        }
        else if (subCollectionViewCells.count>0){
            
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToHandPureMVC getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (collectionViewCount==1) {
                //添加代理方法
                [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
            }else{
                //添加代理方法
                [ZHStoryboardTextManagerToHandPureMVC addDelegateFunctionToText:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
            }
        }
        
        NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
    }
}

@end
