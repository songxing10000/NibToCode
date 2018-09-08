#import "ZHStoryboardTextManagerToHandPureMVC.h"

@implementation ZHStoryboardTextManagerToHandPureMVC
//viewCategory 控件的真名类别  viewName控件customClass的属性值
+ (NSString *)getPropertyWithViewName:(NSString *)viewName withViewCategory:(NSString *)viewCategory{
    //第一个字母大写
    viewCategory=[self upFirstCharacter:viewCategory];
    
    return [NSString stringWithFormat:@"@property (strong, nonatomic) UI%@ *%@;",viewCategory,viewName];
}
+ (void)addDelegateFunctionToText:(NSMutableString *)text withTableViews:(NSDictionary *)tableViewsDic isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews{
    
    NSMutableArray *tableViews=[NSMutableArray array];
    for (NSString *tableView in tableViewsDic) {
        [tableViews addObject:[NSDictionary dictionaryWithObject:tableViewsDic[tableView] forKey:tableView]];
    }
    if (tableViews.count==0) {
        return;
    }
    [self addDelegateTableViewToText:text];
    
    if (tableViews.count==1) {
        
        NSString *oneTableViewName=[tableViewsDic allKeys][0];
        NSString *oneTableViewName_realName=oneTableViewName;
        if (idAndOutletViews[oneTableViewName_realName]!=nil) {
            oneTableViewName_realName=idAndOutletViews[oneTableViewName_realName];
        }
        
        BOOL isonlyOne=NO;
        
        //开始添加 属性和代理
        if(isOnlyTableViewOrCollectionView){
            [self addCodeText:@"@property (strong, nonatomic) NSMutableArray *dataArr;" andInsertType:ZHAddCodeType_Interface toStrM:text insertFunction:nil];
            [self addCodeText:@"- (NSMutableArray *)dataArr{\n\
             if (!_dataArr) {\n\
             _dataArr=[NSMutableArray array];\n\
             }\n\
             return _dataArr;\n\
             }" andInsertType:ZHAddCodeType_Implementation toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;",oneTableViewName_realName,oneTableViewName_realName] andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
            isonlyOne=YES;
        }else{
            NSString *oneTableViewName_new=[self upFirstCharacter:oneTableViewName_realName];
            [self addCodeText:[NSString stringWithFormat:@"@property (strong, nonatomic) NSMutableArray *dataArr%@;",oneTableViewName_new] andInsertType:ZHAddCodeType_Interface toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"- (NSMutableArray *)dataArr%@{\n\
                               if (!_dataArr%@) {\n\
                               _dataArr%@=[NSMutableArray array];\n\
                               }\n\
                               return _dataArr%@;\n\
                               }",oneTableViewName_new,oneTableViewName_new,oneTableViewName_new,oneTableViewName_new] andInsertType:ZHAddCodeType_Implementation toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;",oneTableViewName_realName,oneTableViewName_realName] andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        }
        
        NSMutableString *strM=[NSMutableString string];
        [strM appendFormat:@"#pragma mark - TableView必须实现的方法:\n\
         - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{\n\n\
         return 1;\n\
         }\n\
         - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{\n\n\
         return self.dataArr%@.count;\n\
         }\n",isonlyOne?@"":[self upFirstCharacter:oneTableViewName_realName]];
        [strM appendFormat:@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\n\n\
         id modelObjct=self.dataArr%@[indexPath.row];\n",isonlyOne?@"":[self upFirstCharacter:oneTableViewName_realName]];
        
        NSDictionary *tableDic=tableViews[0];
        NSArray *cells=tableDic[[tableDic allKeys][0]];
        for (NSString *cell in cells) {
            NSString *adapterCell=[ZHStroyBoardFileManager getAdapterTableViewCellName:cell];
            NSString *tempCell=[ZHStoryboardTextManager lowerFirstCharacter:adapterCell];
            [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@TableViewCellModel class]]){\n\
             %@TableViewCell *%@Cell=[tableView dequeueReusableCellWithIdentifier:@\"%@TableViewCell\"];\n\
             %@TableViewCellModel *model=modelObjct;\n\
             [%@Cell refreshUI:model];\n\
             return %@Cell;\n\
             }\n",adapterCell,adapterCell,tempCell,adapterCell,adapterCell,tempCell,tempCell];
        }
        
        //注册cell
        NSMutableString *registerClassText=[NSMutableString string];
        NSString *oneTableViewNameTemp=[tableViewsDic allKeys][0];
        if (idAndOutletViews[oneTableViewNameTemp]!=nil) {
            oneTableViewNameTemp=idAndOutletViews[oneTableViewNameTemp];
        }
        for (NSString *cell in cells) {
            NSString *adapterCell=[ZHStroyBoardFileManager getAdapterTableViewCellName:cell];
            [registerClassText appendFormat:@"[self.%@ registerClass:[%@TableViewCell class] forCellReuseIdentifier:@\"%@TableViewCell\"];\n",oneTableViewNameTemp,adapterCell,adapterCell];
        }
        if(registerClassText.length>0)
            [self addCodeText:registerClassText andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        
        [strM appendString:@"//随便给一个cell\n\
         UITableViewCell *cell=[UITableViewCell new];\n\
         return cell;\n\
         }\n"];
        [strM appendString:@"- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{\n\n\
         return 80.0f;\n\
         }\n\
         - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{\n\
         [tableView deselectRowAtIndexPath:indexPath animated:YES];\n\
         }\n"];
        
        //开始插入
        [self addCodeText:strM andInsertType:ZHAddCodeType_end_last toStrM:text insertFunction:nil];
    }
    else{
        
        NSMutableArray *allTbaleViews=[NSMutableArray array];
        
        NSMutableDictionary *allTableViewDicM=[NSMutableDictionary dictionary];
        for (NSDictionary *tableDic in tableViews) {
            [allTbaleViews addObject:[tableDic allKeys][0]];
            [allTableViewDicM setValue:tableDic[[tableDic allKeys][0]] forKey:[tableDic allKeys][0]];
        }
        
        for (NSString *oneTableViewNameTemp in allTbaleViews) {
            NSString *oneTableViewName=oneTableViewNameTemp;
            if (idAndOutletViews[oneTableViewName]!=nil) {
                oneTableViewName=idAndOutletViews[oneTableViewName];
            }
            NSString *oneTableViewName_new=[self upFirstCharacter:oneTableViewName];
            //开始添加 属性和代理
            [self addCodeText:[NSString stringWithFormat:@"@property (strong, nonatomic) NSMutableArray *dataArr%@;",oneTableViewName_new] andInsertType:ZHAddCodeType_Interface toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"- (NSMutableArray *)dataArr%@{\n\
                               if (!_dataArr%@) {\n\
                               _dataArr%@=[NSMutableArray array];\n\
                               }\n\
                               return _dataArr%@;\n\
                               }",oneTableViewName_new,oneTableViewName_new,oneTableViewName_new,oneTableViewName_new] andInsertType:ZHAddCodeType_Implementation toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;",oneTableViewName,oneTableViewName] andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        }
        
        //注册cell
        NSMutableString *registerClassText=[NSMutableString string];
        
        for (NSInteger i=0; i<allTbaleViews.count; i++) {
            NSString *tableView=allTbaleViews[i];
            NSString *keyTableView=tableView;
            if (idAndOutletViews[tableView]!=nil) {
                tableView=idAndOutletViews[tableView];
            }
            NSArray *cells=allTableViewDicM[keyTableView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterTableViewCellName:cell];
                [registerClassText appendFormat:@"[self.%@ registerClass:[%@TableViewCell class] forCellReuseIdentifier:@\"%@TableViewCell\"];\n",tableView,adapterCell,adapterCell];
            }
        }
        if(registerClassText.length>0)
            [self addCodeText:registerClassText andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        
        NSMutableString *strM=[NSMutableString string];
        [strM appendString:@"#pragma mark - TableView必须实现的方法:\n\
         - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{\n\n"];
        
        for (NSInteger i=0; i<allTbaleViews.count; i++) {
            NSString *tableView=allTbaleViews[i];
            if (idAndOutletViews[tableView]!=nil) {
                tableView=idAndOutletViews[tableView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([tableView isEqual:self.%@]) {\n\
                 return 1;\n\
                 }",tableView];
            }else{
                [strM appendFormat:@"else if ([tableView isEqual:self.%@]){\n\
                 return 1;\n\
                 }",tableView];
            }
        }
        [strM appendString:@"\n"];
        [strM appendFormat:@"	return 1;\n\
         }\n"];
        [strM appendString:@"- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{\n\n"];
        for (NSInteger i=0; i<allTbaleViews.count; i++) {
            NSString *tableView=allTbaleViews[i];
            if (idAndOutletViews[tableView]!=nil) {
                tableView=idAndOutletViews[tableView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([tableView isEqual:self.%@]) {\n\
                 return self.dataArr%@.count;\n\
                 }",tableView,[self upFirstCharacter:tableView]];
            }else{
                [strM appendFormat:@"else if ([tableView isEqual:self.%@]){\n\
                 return self.dataArr%@.count;\n\
                 }",tableView,[self upFirstCharacter:tableView]];
            }
        }
        [strM appendString:@"\n"];
        [strM appendFormat:@"	return 0;\n\
         }\n"];
        [strM appendString:@"- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\n\n"];
        for (NSInteger i=0; i<allTbaleViews.count; i++) {
            NSString *tableView=allTbaleViews[i];
            NSString *keyTableView=tableView;
            if (idAndOutletViews[tableView]!=nil) {
                tableView=idAndOutletViews[tableView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([tableView isEqual:self.%@]) {\n",tableView];
            }else{
                [strM appendFormat:@"else if ([tableView isEqual:self.%@]){\n",tableView];
            }
            [strM appendFormat:@"id modelObjct=self.dataArr%@[indexPath.row];\n",[self upFirstCharacter:tableView]];
            
            NSArray *cells=allTableViewDicM[keyTableView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterTableViewCellName:cell];
                NSString *tempCell=[ZHStoryboardTextManager lowerFirstCharacter:adapterCell];
                [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@TableViewCellModel class]]){\n\
                 %@TableViewCell *%@Cell=[tableView dequeueReusableCellWithIdentifier:@\"%@TableViewCell\"];\n\
                 %@TableViewCellModel *model=modelObjct;\n\
                 [%@Cell refreshUI:model];\n\
                 return %@Cell;\n\
                 }\n",adapterCell,adapterCell,tempCell,adapterCell,adapterCell,tempCell,tempCell];
            }
            [strM appendString:@"}\n"];
        }
        [strM appendString:@"//随便给一个cell\n\
         UITableViewCell *cell=[UITableViewCell new];\n\
         return cell;\n}\n"];
        
        [strM appendString:@"- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{\n\n"];
        for (NSInteger i=0; i<allTbaleViews.count; i++) {
            NSString *tableView=allTbaleViews[i];
            NSString *keyTableView=tableView;
            if (idAndOutletViews[tableView]!=nil) {
                tableView=idAndOutletViews[tableView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([tableView isEqual:self.%@]) {\n",tableView];
            }else{
                [strM appendFormat:@"else if ([tableView isEqual:self.%@]){\n",tableView];
            }
            [strM appendFormat:@"id modelObjct=self.dataArr%@[indexPath.row];\n",[self upFirstCharacter:tableView]];
            NSArray *cells=allTableViewDicM[keyTableView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterTableViewCellName:cell];
                [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@TableViewCellModel class]]){\n\
                 return 80.0f;\n\
                 }\n",adapterCell];
            }
            [strM appendString:@"}\n"];
            
        }
        [strM appendString:@"	return 80.0f;\n\
         }\n"];
        [strM appendString:@"- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{\n\n\
         [tableView deselectRowAtIndexPath:indexPath animated:YES];\n"];
        for (NSInteger i=0; i<allTbaleViews.count; i++) {
            NSString *tableView=allTbaleViews[i];
            NSString *keyTableView=tableView;
            if (idAndOutletViews[tableView]!=nil) {
                tableView=idAndOutletViews[tableView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([tableView isEqual:self.%@]) {\n",tableView];
            }else{
                [strM appendFormat:@"else if ([tableView isEqual:self.%@]){\n",tableView];
            }
            [strM appendFormat:@"id modelObjct=self.dataArr%@[indexPath.row];\n",[self upFirstCharacter:tableView]];
            NSArray *cells=allTableViewDicM[keyTableView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterTableViewCellName:cell];
                [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@TableViewCellModel class]]){\n\n\
                 }",adapterCell];
            }
            [strM appendString:@"\n}\n"];
        }
        [strM appendString:@"}\n"];
        //开始插入
        [self addCodeText:strM andInsertType:ZHAddCodeType_end_last toStrM:text insertFunction:nil];
    }
    
}
+ (void)addDelegateFunctionToText:(NSMutableString *)text withCollectionViews:(NSDictionary *)collectionViewsDic isOnlyTableViewOrCollectionView:(BOOL)isOnlyTableViewOrCollectionView withIdAndOutletViewsDic:(NSDictionary *)idAndOutletViews{
    
    NSMutableArray *collectionViews=[NSMutableArray array];
    for (NSString *collectionView in collectionViewsDic) {
        [collectionViews addObject:[NSDictionary dictionaryWithObject:collectionViewsDic[collectionView] forKey:collectionView]];
    }
    if (collectionViews.count==0) {
        return;
    }
    [self addDelegateCollectionViewToText:text];
    
    if (collectionViews.count==1) {
        
        NSString *oneCollectionViewName=[collectionViewsDic allKeys][0];
        NSString *oneCollectionViewName_realName=oneCollectionViewName;
        if (idAndOutletViews[oneCollectionViewName_realName]!=nil) {
            oneCollectionViewName_realName=idAndOutletViews[oneCollectionViewName_realName];
        }
        
        BOOL isonlyOne=NO;
        
        //开始添加 属性和代理
        if(isOnlyTableViewOrCollectionView){
            [self addCodeText:@"@property (strong, nonatomic) NSMutableArray *dataArr;" andInsertType:ZHAddCodeType_Interface toStrM:text insertFunction:nil];
            [self addCodeText:@"- (NSMutableArray *)dataArr{\n\
             if (!_dataArr) {\n\
             _dataArr=[NSMutableArray array];\n\
             }\n\
             return _dataArr;\n\
             }" andInsertType:ZHAddCodeType_Implementation toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;",oneCollectionViewName_realName,oneCollectionViewName_realName] andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
            isonlyOne=YES;
            
        }else{
            NSString *oneCollectionViewName_new=[self upFirstCharacter:oneCollectionViewName_realName];
            [self addCodeText:[NSString stringWithFormat:@"@property (strong, nonatomic) NSMutableArray *dataArr%@;",oneCollectionViewName_new] andInsertType:ZHAddCodeType_Interface toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"- (NSMutableArray *)dataArr%@{\n\
                               if (!_dataArr%@) {\n\
                               _dataArr%@=[NSMutableArray array];\n\
                               }\n\
                               return _dataArr%@;\n\
                               }",oneCollectionViewName_new,oneCollectionViewName_new,oneCollectionViewName_new,oneCollectionViewName_new] andInsertType:ZHAddCodeType_Implementation toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;",oneCollectionViewName_realName,oneCollectionViewName_realName] andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        }
        
        NSMutableString *strM=[NSMutableString string];
        [strM appendFormat:@"#pragma mark - collectionView的代理方法:\n\
         // 1.返回组数:\n\
         - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView\n\
         {\n\
         return 1;\n\
         }\n\
         // 2.返回每一组item的个数:\n\
         - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section\n\
         {\n\
         return self.dataArr%@.count;\n\
         }\n",isonlyOne?@"":[self upFirstCharacter:oneCollectionViewName_realName]];
        
        [strM appendFormat:@"// 3.返回每一个item（cell）对象;\n\
         - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath\n\
         {\n\
         id modelObjct=self.dataArr%@[indexPath.row];\n",isonlyOne?@"":[self upFirstCharacter:oneCollectionViewName_realName]];
        
        NSDictionary *collectionDic=collectionViews[0];
        NSArray *cells=collectionDic[[collectionDic allKeys][0]];
        
        for (NSString *cell in cells) {
            NSString *adapterCell=[ZHStroyBoardFileManager getAdapterCollectionViewCellName:cell];
            NSString *tempCell=[ZHStoryboardTextManager lowerFirstCharacter:adapterCell];
            [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@CollectionViewCellModel class]]) {\n\
             %@CollectionViewCell *%@Cell=[collectionView dequeueReusableCellWithReuseIdentifier:@\"%@CollectionViewCell\" forIndexPath:indexPath];\n\
             %@CollectionViewCellModel *model=modelObjct;\n\
             [%@Cell refreshUI:model];\n\
             return %@Cell;\n\
             }\n",adapterCell,adapterCell,tempCell,adapterCell,adapterCell,tempCell,tempCell];
        }
        
        
        //注册cell
        NSMutableString *registerClassText=[NSMutableString string];
        NSString *oneCollectionViewNameTemp=[collectionViewsDic allKeys][0];
        if (idAndOutletViews[oneCollectionViewNameTemp]!=nil) {
            oneCollectionViewNameTemp=idAndOutletViews[oneCollectionViewNameTemp];
        }
        
        for (NSString *cell in cells) {
            NSString *adapterCell=[ZHStroyBoardFileManager getAdapterCollectionViewCellName:cell];
            [registerClassText appendFormat:@"[self.%@ registerClass:[%@CollectionViewCell class] forCellWithReuseIdentifier:@\"%@CollectionViewCell\"];\n",oneCollectionViewNameTemp,adapterCell,adapterCell];
        }
        
        if(registerClassText.length>0)
            [self addCodeText:registerClassText andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        
        [strM appendString:@"    //随便给一个cell\n\
         UICollectionViewCell *cell=[UICollectionViewCell new];\n\
         return cell;\n\
         }\n"];
        [strM appendString:@"//4.每一个item的大小:\n\
         - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath\n\
         {\n\
         return CGSizeMake(100, 100);\n\
         }\n\
         // 5.选择某一个cell:\n\
         - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath\n\
         {\n\
         [collectionView deselectItemAtIndexPath:indexPath animated:YES];\n\
         }\n"];
        
        //开始插入
        [self addCodeText:strM andInsertType:ZHAddCodeType_end_last toStrM:text insertFunction:nil];
    }else{
        
        NSMutableArray *allCollectionViews=[NSMutableArray array];
        
        NSMutableDictionary *allCollectionViewDicM=[NSMutableDictionary dictionary];
        for (NSDictionary *collectionDic in collectionViews) {
            [allCollectionViews addObject:[collectionDic allKeys][0]];
            [allCollectionViewDicM setValue:collectionDic[[collectionDic allKeys][0]] forKey:[collectionDic allKeys][0]];
        }
        
        //注册cell
        NSMutableString *registerClassText=[NSMutableString string];
        for (NSInteger i=0; i<allCollectionViews.count; i++) {
            NSString *collectionView=allCollectionViews[i];
            NSString *keyCollectionView=collectionView;
            if (idAndOutletViews[collectionView]!=nil) {
                collectionView=idAndOutletViews[collectionView];
            }
            NSArray *cells=allCollectionViewDicM[keyCollectionView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterCollectionViewCellName:cell];
                [registerClassText appendFormat:@"[self.%@ registerClass:[%@CollectionViewCell class] forCellWithReuseIdentifier:@\"%@CollectionViewCell\"];\n",collectionView,adapterCell,adapterCell];
            }
        }
        if(registerClassText.length>0)
            [self addCodeText:registerClassText andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        
        for (NSString *oneCollectionViewNameTemp in allCollectionViews) {
            NSString *oneCollectionViewName=oneCollectionViewNameTemp;
            if (idAndOutletViews[oneCollectionViewName]!=nil) {
                oneCollectionViewName=idAndOutletViews[oneCollectionViewName];
            }
            
            NSString *oneTableViewName_new=[self upFirstCharacter:oneCollectionViewName];
            //开始添加 属性和代理
            [self addCodeText:[NSString stringWithFormat:@"@property (strong, nonatomic) NSMutableArray *dataArr%@;",oneTableViewName_new] andInsertType:ZHAddCodeType_Interface toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"- (NSMutableArray *)dataArr%@{\n\
                               if (!_dataArr%@) {\n\
                               _dataArr%@=[NSMutableArray array];\n\
                               }\n\
                               return _dataArr%@;\n\
                               }",oneTableViewName_new,oneTableViewName_new,oneTableViewName_new,oneTableViewName_new] andInsertType:ZHAddCodeType_Implementation toStrM:text insertFunction:nil];
            [self addCodeText:[NSString stringWithFormat:@"self.%@.delegate=self;\nself.%@.dataSource=self;",oneCollectionViewName,oneCollectionViewName] andInsertType:ZHAddCodeType_InsertFunction toStrM:text insertFunction:@"- (void)viewDidLoad{"];
        }
        
        NSMutableString *strM=[NSMutableString string];
        [strM appendString:@"#pragma mark - collectionView的代理方法:\n\
         // 1.返回组数:\n\
         - (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView\n\
         {\n\n"];
        
        for (NSInteger i=0; i<allCollectionViews.count; i++) {
            NSString *collectionView=allCollectionViews[i];
            if (idAndOutletViews[collectionView]!=nil) {
                collectionView=idAndOutletViews[collectionView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([collectionView isEqual:self.%@]) {\n\
                 return 1;\n\
                 }",collectionView];
            }else{
                [strM appendFormat:@"else if([collectionView isEqual:self.%@]){\n\
                 return 1;\n\
                 }",collectionView];
            }
        }
        [strM appendString:@"\n"];
        [strM appendFormat:@"	return 1;\n\
         }\n"];
        [strM appendString:@"// 2.返回每一组item的个数:\n\
         - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section\n\
         {\n\n"];
        for (NSInteger i=0; i<allCollectionViews.count; i++) {
            NSString *collectionView=allCollectionViews[i];
            if (idAndOutletViews[collectionView]!=nil) {
                collectionView=idAndOutletViews[collectionView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([collectionView isEqual:self.%@]) {\n\
                 return self.dataArr%@.count;\n\
                 }",collectionView,[self upFirstCharacter:collectionView]];
            }else{
                [strM appendFormat:@"else if([collectionView isEqual:self.%@]){\n\
                 return self.dataArr%@.count;\n\
                 }",collectionView,[self upFirstCharacter:collectionView]];
            }
        }
        [strM appendString:@"\n"];
        [strM appendFormat:@"	return 0;\n\
         }\n"];
        [strM appendString:@"// 3.返回每一个item（cell）对象;\n\
         - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath\n\
         {\n\n"];
        for (NSInteger i=0; i<allCollectionViews.count; i++) {
            NSString *collectionView=allCollectionViews[i];
            NSString *keyCollectionView=collectionView;
            if (idAndOutletViews[collectionView]!=nil) {
                collectionView=idAndOutletViews[collectionView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([collectionView isEqual:self.%@]) {\n",collectionView];
            }else{
                [strM appendFormat:@"else if ([collectionView isEqual:self.%@]){\n",collectionView];
            }
            [strM appendFormat:@"id modelObjct=self.dataArr%@[indexPath.row];\n",[self upFirstCharacter:collectionView]];
            NSArray *cells=allCollectionViewDicM[keyCollectionView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterCollectionViewCellName:cell];
                NSString *tempCell=[ZHStoryboardTextManager lowerFirstCharacter:adapterCell];
                [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@CollectionViewCellModel class]]) {\n\
                 %@CollectionViewCell *%@Cell=[collectionView dequeueReusableCellWithReuseIdentifier:@\"%@CollectionViewCell\" forIndexPath:indexPath];\n\
                 %@CollectionViewCellModel *model=modelObjct;\n\
                 [%@Cell refreshUI:model];\n\
                 return %@Cell;\n\
                 }\n",adapterCell,adapterCell,tempCell,adapterCell,adapterCell,tempCell,tempCell];
            }
            [strM appendString:@"}\n"];
        }
        [strM appendString:@"//随便给一个cell\n\
         UICollectionViewCell *cell=[UICollectionViewCell new];\n\
         return cell;\n\
         }\n"];
        
        [strM appendString:@"//4.每一个item的大小:\n\
         - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath\n\
         {\n\n"];
        for (NSInteger i=0; i<allCollectionViews.count; i++) {
            NSString *collectionView=allCollectionViews[i];
            NSString *keyCollectionView=collectionView;
            if (idAndOutletViews[collectionView]!=nil) {
                collectionView=idAndOutletViews[collectionView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([collectionView isEqual:self.%@]) {\n",collectionView];
            }else{
                [strM appendFormat:@"else if ([collectionView isEqual:self.%@]){\n",collectionView];
            }
            [strM appendFormat:@"id modelObjct=self.dataArr%@[indexPath.row];\n",[self upFirstCharacter:collectionView]];
            NSArray *cells=allCollectionViewDicM[keyCollectionView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterCollectionViewCellName:cell];
                [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@CollectionViewCellModel class]]){\n\
                 return CGSizeMake(100, 100);\n\
                 }\n",adapterCell];
            }
            [strM appendString:@"}\n"];
            
        }
        [strM appendString:@"	return CGSizeMake(100, 100);\n\
         }\n"];
        [strM appendString:@"// 5.选择某一个cell:\n\
         - (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath\n\
         {\n\
         [collectionView deselectItemAtIndexPath:indexPath animated:YES];\n"];
        for (NSInteger i=0; i<allCollectionViews.count; i++) {
            NSString *collectionView=allCollectionViews[i];
            NSString *keyCollectionView=collectionView;
            if (idAndOutletViews[collectionView]!=nil) {
                collectionView=idAndOutletViews[collectionView];
            }
            if (i==0) {
                [strM appendFormat:@"if ([collectionView isEqual:self.%@]) {\n",collectionView];
            }else{
                [strM appendFormat:@"else if ([collectionView isEqual:self.%@]){\n",collectionView];
            }
            [strM appendFormat:@"id modelObjct=self.dataArr%@[indexPath.row];\n",[self upFirstCharacter:collectionView]];
            NSArray *cells=allCollectionViewDicM[keyCollectionView];
            for (NSString *cell in cells) {
                NSString *adapterCell=[ZHStroyBoardFileManager getAdapterCollectionViewCellName:cell];
                [strM appendFormat:@"if ([modelObjct isKindOfClass:[%@CollectionViewCellModel class]]){\n\n\
                 }",adapterCell];
            }
            [strM appendString:@"\n}\n"];
        }
        [strM appendString:@"}\n"];
        //开始插入
        [self addCodeText:strM andInsertType:ZHAddCodeType_end_last toStrM:text insertFunction:nil];
    }
}
@end
