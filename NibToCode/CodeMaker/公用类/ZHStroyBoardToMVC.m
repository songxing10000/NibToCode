#import "ZHStroyBoardToMVC.h"
#import "ZHStoryboardTextManagerToMVC.h"
#import "ZHStroyBoardFileManagerToMVC.h"


@interface ZHStroyBoardToMVC ()
@property (nonatomic,strong)NSDictionary *customAndId;
@property (nonatomic,strong)NSDictionary *customAndName;
@property (nonatomic,strong)NSDictionary *idAndViewPropertys;
@property (nonatomic,strong)NSDictionary *idAndOutletViews;
@property (nonatomic,strong)NSDictionary *idAndViews;
@end
@implementation ZHStroyBoardToMVC
- (NSString *)StroyBoard_To_MVC:(NSString *)stroyBoard{
    NSString *filePath=stroyBoard;
    
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        return @"";
    }
    
    NSString *context=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    context=[ZHStoryboardTextManagerToMVC addCustomClassToAllViews:context];
    
    ReadXML *xml=[ReadXML new];
    [xml initWithXMLString:context];
    
    NSDictionary *MyDic=[xml TreeToDict:xml.rootElement];
    
    NSArray *allViewControllers=[ZHStoryboardXMLManager getAllViewControllerWithDic:MyDic andXMLHandel:xml];
    
    //    获取所有的ViewController名字
    NSArray *viewControllers=[ZHStoryboardXMLManager getViewControllerCountNamesWithAllViewControllerArrM:allViewControllers];
    
    for (NSString *viewController in viewControllers) {
        //创建MVC文件夹
        [ZHStroyBoardFileManagerToMVC creat_MVC_WithViewControllerName:viewController];
        //创建对应的ViewController文件
        [ZHStroyBoardFileManagerToMVC creat_m_h_file:viewController isModel:NO isView:NO isController:YES isTableView:YES isCollectionView:NO forViewController:viewController];
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
                    [ZHStroyBoardFileManagerToMVC creat_m_h_file:tableViewCell isModel:NO isView:YES isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                    //创建对应的Model文件
                    [ZHStroyBoardFileManagerToMVC creat_m_h_file:tableViewCell isModel:YES isView:NO isController:NO isTableView:YES isCollectionView:NO forViewController:viewController];
                }
                
                NSArray *allCollectionViewCells=[ZHStoryboardXMLManager getAllCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
                for (NSString *collectionViewCell in allCollectionViewCells) {
                    //创建对应的CellView文件
                    [ZHStroyBoardFileManagerToMVC creat_m_h_file:collectionViewCell isModel:NO isView:YES isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
                    //创建对应的Model文件
                    [ZHStroyBoardFileManagerToMVC creat_m_h_file:collectionViewCell isModel:YES isView:NO isController:NO isTableView:NO isCollectionView:YES forViewController:viewController];
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
                    [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                for (NSString *collectionViewCell in collectionViewCells) {
                    [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                }
                
                //插入属性property
                NSArray *views=[ZHStoryboardXMLManager getAllViewControllerSubViewsWithViewControllerDic:dic andXMLHandel:xml];
                
                for (NSString *idStr in views) {
                    //这里获取的属性不包括特殊控件,比如tableView,collectionView
                    NSString *property=[ZHStoryboardTextManagerToMVC getPropertyWithViewName:self.idAndOutletViews[idStr] withViewCategory:customAndName[idStr]];
                    
                    if (property.length>0) {
                        [ZHStoryboardTextManagerToMVC addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
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
                
                for (NSString *idStr in views) {
                    NSString *selectorEventType=[ZHStoryboardPropertyManager getSelectorEventTypeForViewNameForNoPureHand:idStr withProperty:self.idAndViewPropertys[idStr]];
                    if (selectorEventType.length>0) {
                        [ZHStoryboardTextManagerToMVC addCodeText:selectorEventType andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:viewControllerFileName] insertFunction:nil];
                    }
                }
                
                //解决UIMapView *mapView1;的问题
                [ZHStoryboardTextManagerToMVC dealWith_UIMapView:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] needInserFramework:YES];
                
                //再添加代码
                if(tableViewCellDic.count>0&&collectionViewCellDic.count>0){
                    
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[ZHStoryboardTextManagerToMVC getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"1-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToMVC getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"2-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    //添加代理方法
                    [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                    [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                }
                else if (tableViewCellDic.count>0){
                    //获取该ViewController的tableview的个数
                    NSInteger tableViewCount=tableViewCellDic.count;
                    
                    NSInteger tableViewCount_new=[ZHStoryboardTextManagerToMVC getTableViewCount:views];
                    if (tableViewCount_new!=tableViewCount) {
                        NSLog(@"3-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    if (tableViewCount==1) {
                        //添加代理方法
                        [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
                    }else{
                        //添加代理方法
                        [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] withTableViews:tableViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                    }
                    
                }
                else if (collectionViewCellDic.count>0){
                    
                    //获取该ViewController的collectionview的个数
                    NSInteger collectionViewCount=collectionViewCellDic.count;
                    
                    NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToMVC getCollectionViewCount:views];
                    if (collectionViewCount!=collectionViewCount_new) {
                        NSLog(@"4-%@:%@",viewController,@"筛选没有筛选完");
                    }
                    
                    if (collectionViewCount==1) {
                        //添加代理方法
                        [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
                    }else{
                        //添加代理方法
                        [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:viewControllerFileName] withCollectionViews:collectionViewCellDic isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
                    }
                }
            }
            
            NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:dic andXMLHandel:xml];
            
            [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
            [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        }
    }
    
    NSString *mainPath=[ZHStroyBoardFileManagerToMVC getMainDirectory];
    
    NSInteger count=0;
    
    count=[ZHStoryboardTextManagerToMVC getAllViewCount];
    
    //这句话一定要加
    [ZHStroyBoardFileManagerToMVC done];
    [ZHStoryboardTextManagerToMVC done];
    
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
        [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManagerToMVC get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        //再添加refreshUI方法
        [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"- (void)refreshUI:(%@ *)dataModel;",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManagerToMVC get_H_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //给.m文件添加model弱引用
        [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"@property (weak, nonatomic) %@ *dataModel;//model弱引用\n",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        //给.m文件添加refreshUI
        [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"\n- (void)refreshUI:(%@ *)dataModel{\n_dataModel=dataModel;\n\
                                              \n\
                                              }",[fatherCellName stringByAppendingString:@"Model"]] andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] insertFunction:nil];
        
        
        NSDictionary *subTableViewCells=[ZHStoryboardXMLManager getAllTableViewAndTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subTableViewCells.count>0) {
            //插入#import
            for (NSString *tableViewName in subTableViewCells) {
                NSArray *tableViewCells=subTableViewCells[tableViewName];
                for (NSString *tableViewCell in tableViewCells) {
                    [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",tableViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        NSDictionary *subCollectionViewCells=[ZHStoryboardXMLManager getAllCollectionViewAndCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        if (subCollectionViewCells.count>0) {
            for (NSString *collectionViewName in subCollectionViewCells) {
                NSArray *collectionViewCells=subCollectionViewCells[collectionViewName];
                for (NSString *collectionViewCell in collectionViewCells) {
                    [ZHStoryboardTextManagerToMVC addCodeText:[NSString stringWithFormat:@"#import \"%@.h\"",collectionViewCell] andInsertType:ZHAddCodeType_Import toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] insertFunction:nil];
                }
            }
        }
        
        //插入属性property
        NSArray *views=[ZHStoryboardXMLManager getAllCellSubViewsWithViewControllerDic:subDic andXMLHandel:xml];
        
        for (NSString *idStr in views) {
            
            //这里获取的属性不包括特殊控件,比如tableView,collectionView
            NSString *property=[ZHStoryboardTextManagerToMVC getPropertyWithViewName:self.idAndOutletViews[idStr] withViewCategory:self.customAndName[idStr]];
            
            if (property.length>0) {
                [ZHStoryboardTextManagerToMVC addCodeText:property andInsertType:ZHAddCodeType_Interface toStrM:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] insertFunction:nil];
            }
        }
        
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
        
        for (NSString *idStr in views) {
            NSString *selectorEventType=[ZHStoryboardPropertyManager getSelectorEventTypeForViewNameForNoPureHand:idStr withProperty:self.idAndViewPropertys[idStr]];
            if (selectorEventType.length>0) {
                [ZHStoryboardTextManagerToMVC addCodeText:selectorEventType andInsertType:ZHAddCodeType_Implementation toStrM:[ZHStroyBoardFileManager get_M_ContextByIdentity:NewFileName] insertFunction:nil];
            }
        }
        
        //解决UIMapView *mapView1;的问题
        [ZHStoryboardTextManagerToMVC dealWith_UIMapView:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] needInserFramework:YES];
        
        
        //再添加代码
        if(subTableViewCells.count>0&&subCollectionViewCells.count>0){
            
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger tableViewCount_new=[ZHStoryboardTextManagerToMVC getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToMVC getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            //添加代理方法
            [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
            [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
        }
        else if (subTableViewCells.count>0){
            //获取该ViewController的tableview的个数
            NSInteger tableViewCount=subTableViewCells.count;
            
            NSInteger tableViewCount_new=[ZHStoryboardTextManagerToMVC getTableViewCount:views];
            if (tableViewCount_new!=tableViewCount) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (tableViewCount==1) {
                //添加代理方法
                [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
            }else{
                //添加代理方法
                [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] withTableViews:subTableViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
            }
            
        }
        else if (subCollectionViewCells.count>0){
            
            //获取该ViewController的collectionview的个数
            NSInteger collectionViewCount=subCollectionViewCells.count;
            
            NSInteger collectionViewCount_new=[ZHStoryboardTextManagerToMVC getCollectionViewCount:views];
            if (collectionViewCount!=collectionViewCount_new) {
                NSLog(@"%@",@"筛选没有筛选完");
            }
            
            if (collectionViewCount==1) {
                //添加代理方法
                [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:YES withIdAndOutletViewsDic:self.idAndOutletViews];
            }else{
                //添加代理方法
                [ZHStoryboardTextManagerToMVC addDelegateFunctionToText:[ZHStroyBoardFileManagerToMVC get_M_ContextByIdentity:NewFileName] withCollectionViews:subCollectionViewCells isOnlyTableViewOrCollectionView:NO withIdAndOutletViewsDic:self.idAndOutletViews];
            }
        }
        
        NSArray *tableViewCellDic=[ZHStoryboardXMLManager getTableViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        NSArray *collectionViewCellDic=[ZHStoryboardXMLManager getCollectionViewCellNamesWithViewControllerDic:subDic andXMLHandel:xml];
        
        [self detailSubCells:tableViewCellDic andXMLHandel:xml withFatherViewController:viewController];
        [self detailSubCells:collectionViewCellDic andXMLHandel:xml withFatherViewController:viewController];
    }
}

@end
