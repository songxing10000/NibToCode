

@interface CreatFatherFile : NSObject
/**把文件内容转换成字典*/
- (NSDictionary *)getDicFromFileName:(NSString *)fileName;
/**创建文件根据数组*/
- (NSString *)creatFatherFile:(NSString *)fileName andData:(NSArray *)arrData;
/**插入一行到可变字符串中,并且换行*/
- (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM;
+ (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM;
/**创建文件夹*/
- (NSString *)creatFatherFileDirector:(NSString *)directorName toFatherDirector:(NSString *)fatherDirectorName;
/**判断是否有填写*/
- (BOOL)judge:(NSString *)text;

/**打开某个文件*/
- (void)openFile:(NSString *)fileName;

- (void)saveText:(NSString *)text toFileName:(NSArray *)fileNameDegree;
- (void)saveStoryBoardCollectionViewToViewController:(NSString *)ViewController collectionviewCells:(NSArray *)collectionviewCells toFileName:(NSArray *)fileNameDegree;
- (void)saveStoryBoard:(NSString *)ViewController TableViewCells:(NSArray *)tableviewCells toFileName:(NSArray *)fileNameDegree;
- (void)saveStoryBoard:(NSString *)ViewController TableViewCells:(NSArray *)tableviewCells subTableCells:(NSArray *)subTableCellDic toFileName:(NSArray *)fileNameDegree;

- (NSString *)getDirectoryPath:(NSString *)fileName;

- (void)backUp:(NSString *)fileName;
- (NSString *)getStoryBoardIdString;
@end
