#import "CreatFatherFile.h"

@implementation CreatFatherFile

- (BOOL)judge:(NSString *)text{
    if (text.length==0||[text isEqualToString:@"请填写"]||[text isEqualToString:@"<#请填写#>"]) {
        return NO;
    }
    return YES;
}

- (void)backUp:(NSString *)fileName{
    if ([fileName hasSuffix:@".m"]) fileName=[fileName substringToIndex:fileName.length-2];
    
    NSString *filePathTemp=[[ZHFileManager getMacDesktop] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",fileName]];
    NSString *text=[NSString stringWithContentsOfFile:filePathTemp encoding:NSUTF8StringEncoding error:nil];
    
    NSString *filePath=[[ZHFileManager getMacDesktop] stringByAppendingPathComponent:@"Log.m"];
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        [ZHFileManager createFileAtPath:filePath];
    }
    NSString *content=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *curTime=[self getDateString:[NSDate date]];
    curTime=[@"#pragma mark -----------"stringByAppendingString:curTime];
    curTime=[curTime stringByAppendingString:@"-----------\n"];
    text=[curTime stringByAppendingString:text];
    text=[text stringByAppendingString:@"\n"];
    content=[text stringByAppendingString:content];
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

/**获取某个时间的字符串*/
- (NSString *)getDateString:(NSDate *)date{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

- (NSString *)getInfoFromDic:(NSArray *)arr{
    
    NSMutableString *strM=[NSMutableString string];
    
    [strM setString:@"{\n"];
    for (NSInteger i=0; i<arr.count; i++) {
        if (i!=arr.count-1) {
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"\"%@\":\"<#请填写#>\",",arr[i]]] ToStrM:strM];
        }else{
            [self insertValueAndNewlines:@[[NSString stringWithFormat:@"\"%@\":\"<#请填写#>\"",arr[i]]] ToStrM:strM];
        }
    }
    [strM appendString:@"}"];
    
    return strM;
}
- (NSDictionary *)getDicFromFileName:(NSString *)fileName{
    NSString *filePath=[ZHFileManager getMacDesktop];
    
    if ([fileName hasSuffix:@".m"]) {
        filePath =[filePath stringByAppendingPathComponent:fileName];
    }else{
        filePath =[filePath stringByAppendingPathComponent:[fileName stringByAppendingString:@".m"]];
    }
    
    if ([ZHFileManager fileExistsAtPath:filePath]==NO) {
        return nil;
    }
    
    NSString *strTemp=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [NSJSONSerialization JSONObjectWithData:[strTemp dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}

- (NSString *)creatFatherFile:(NSString *)fileName andData:(NSArray *)arrData{
    
    NSString *filePath=[ZHFileManager getMacDesktop];
    if ([fileName hasSuffix:@".m"]) {
        filePath =[filePath stringByAppendingPathComponent:fileName];
    }else{
        filePath =[filePath stringByAppendingPathComponent:[fileName stringByAppendingString:@".m"]];
    }
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self getInfoFromDic:arrData]dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    return filePath;
}
- (void)saveText:(NSString *)text toFileName:(NSArray *)fileNameDegree{
    NSString *filePath=[ZHFileManager getMacDesktop];
    
    for (NSInteger i=0; i<fileNameDegree.count; i++) {
        if (![fileNameDegree[i] hasPrefix:@"."]) {
            filePath =[filePath stringByAppendingPathComponent:fileNameDegree[i]];
        }else{
            filePath =[filePath stringByAppendingString:fileNameDegree[i]];
        }
    }
    
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:[text dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}
- (NSString *)getDirectoryPath:(NSString *)fileName{
    NSString *filePath=[ZHFileManager getMacDesktop];
    filePath =[filePath stringByAppendingPathComponent:fileName];
    return filePath;
}

- (void)saveStoryBoardCollectionViewToViewController:(NSString *)ViewController collectionviewCells:(NSArray *)collectionviewCells toFileName:(NSArray *)fileNameDegree{
    NSString *filePath=[ZHFileManager getMacDesktop];
    
    for (NSInteger i=0; i<fileNameDegree.count; i++) {
        if (![fileNameDegree[i] hasPrefix:@"."]) {
            filePath =[filePath stringByAppendingPathComponent:fileNameDegree[i]];
        }else{
            filePath =[filePath stringByAppendingString:fileNameDegree[i]];
        }
    }
    
    [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self CollectionViewController:ViewController collectionViewCells:collectionviewCells] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}
- (void)saveStoryBoard:(NSString *)ViewController TableViewCells:(NSArray *)tableviewCells toFileName:(NSArray *)fileNameDegree{
    NSString *filePath=[ZHFileManager getMacDesktop];
    
    for (NSInteger i=0; i<fileNameDegree.count; i++) {
        if (![fileNameDegree[i] hasPrefix:@"."]) {
            filePath =[filePath stringByAppendingPathComponent:fileNameDegree[i]];
        }else{
            filePath =[filePath stringByAppendingString:fileNameDegree[i]];
        }
    }
    
    if (ViewController.length<=0) {
        [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self NoViewController] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else if (ViewController.length>0){
        if (tableviewCells.count==0) {
            [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self ViewController] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }else if(tableviewCells.count>0){
            [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self ViewController:ViewController TableViewCells:tableviewCells] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
    }
}

- (void)saveStoryBoard:(NSString *)ViewController TableViewCells:(NSArray *)tableviewCells subTableCells:(NSArray *)subTableCellDicArr toFileName:(NSArray *)fileNameDegree{
    NSString *filePath=[ZHFileManager getMacDesktop];
    
    for (NSInteger i=0; i<fileNameDegree.count; i++) {
        if (![fileNameDegree[i] hasPrefix:@"."]) {
            filePath =[filePath stringByAppendingPathComponent:fileNameDegree[i]];
        }else{
            filePath =[filePath stringByAppendingString:fileNameDegree[i]];
        }
    }
    
    if (ViewController.length<=0) {
        [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self NoViewController] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    }else if (ViewController.length>0){
        if (tableviewCells.count==0) {
            [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self ViewController] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }else if(tableviewCells.count>0){
            [[NSFileManager defaultManager]createFileAtPath:filePath contents:[[self ViewController:ViewController TableViewCells:tableviewCells subTableCells:subTableCellDicArr] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        }
    }
}

- (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM{
    
    if (strM==nil) {
        strM=[NSMutableString string];
    }
    
    for (NSString  *str in values) {
        [strM appendFormat:@"%@\n",str];
    }
    
}
+ (void)insertValueAndNewlines:(NSArray *)values ToStrM:(NSMutableString *)strM{
    
    if (strM==nil) {
        strM=[NSMutableString string];
    }
    
    for (NSString  *str in values) {
        [strM appendFormat:@"%@\n",str];
    }
    
}
- (NSString *)creatFatherFileDirector:(NSString *)directorName toFatherDirector:(NSString *)fatherDirectorName{
    NSString *filePath=[ZHFileManager getMacDesktop];
    
    if (fatherDirectorName.length==0) {
        filePath =[filePath stringByAppendingPathComponent:directorName];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        [[NSFileManager defaultManager]createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        filePath = [fatherDirectorName stringByAppendingPathComponent:directorName];
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        }
        [[NSFileManager defaultManager]createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}

/**打开某个文件*/
- (void)openFile:(NSString *)fileName{
    if ([[NSFileManager defaultManager]fileExistsAtPath:fileName]) {
//        NSString *open=[NSString stringWithFormat:@"open %@",fileName];
//        system([open UTF8String]);
    }
}

#pragma mark- StoryBoard生成相关函数
- (NSString *)ViewController{
    return @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" initialViewController=\"BYZ-38-t0r\">\n\
    <dependencies>\n\
    <deployment identifier=\"iOS\"/>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes>\n\
    <!--View Controller-->\n\
    <scene sceneID=\"tne-QT-ifu\">\n\
    <objects>\n\
    <viewController id=\"BYZ-38-t0r\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n\
    <layoutGuides>\n\
    <viewControllerLayoutGuide type=\"top\" id=\"y3c-jy-aDJ\"/>\n\
    <viewControllerLayoutGuide type=\"bottom\" id=\"wfy-db-euE\"/>\n\
    </layoutGuides>\n\
    <view key=\"view\" contentMode=\"scaleToFill\" id=\"8bC-Xf-vdC\">\n\
    <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
    <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
    <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>\n\
    </view>\n\
    </viewController>\n\
    <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dkx-z0-nzr\" sceneMemberID=\"firstResponder\"/>\n\
    </objects>\n\
    </scene>\n\
    </scenes>\n\
    </document>";
}
- (NSString *)NoViewController{
    return @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
    <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
    <dependencies>\n\
    <deployment identifier=\"iOS\"/>\n\
    <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
    </dependencies>\n\
    <scenes/>\n\
    </document>\n";
}

- (NSString *)CollectionViewController:(NSString *)viewController collectionViewCells:(NSArray *)collectionViewCells{
    NSMutableString *text=[NSMutableString string];
    
    [text appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
     <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" initialViewController=\"BYZ-38-t0r\">\n\
     <dependencies>\n\
     <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
     </dependencies>\n\
     <scenes>\n\
     <!--View Controller-->\n\
     <scene sceneID=\"tne-QT-ifu\">\n\
     <objects>\n"];
    
    
    if (viewController.length>0) {
        [text appendFormat:@"<viewController storyboardIdentifier=\"%@ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"mVP-Cm-krS\" customClass=\"%@ViewController\" sceneMemberID=\"viewController\">\n",viewController,viewController];
    }else{
        [text appendFormat:@"<viewController storyboardIdentifier=\"ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n"];
    }
    
    [text appendString:@"<layoutGuides>\n\
     <viewControllerLayoutGuide type=\"top\" id=\"7cz-NE-Ze6\"/>\n\
     <viewControllerLayoutGuide type=\"bottom\" id=\"4Vf-XF-v7h\"/>\n\
     </layoutGuides>\n\
     <view key=\"view\" contentMode=\"scaleToFill\" id=\"D83-1j-lmx\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
     <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
     <subviews>\n\
     <collectionView clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"scaleToFill\" dataMode=\"prototypes\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"hB6-Qs-mJM\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
     <collectionViewFlowLayout key=\"collectionViewLayout\" minimumLineSpacing=\"10\" minimumInteritemSpacing=\"10\" id=\"I30-Un-Hin\">\n\
     <size key=\"itemSize\" width=\"179\" height=\"225\"/>\n\
     <size key=\"headerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
     <size key=\"footerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
     <inset key=\"sectionInset\" minX=\"0.0\" minY=\"0.0\" maxX=\"0.0\" maxY=\"0.0\"/>\n\
     </collectionViewFlowLayout>\n\
     <cells>\n"];
    
    if (collectionViewCells.count>0) {\
        for (NSString *cells in collectionViewCells) {
            NSString *idText=[self getStoryBoardIdString];
            NSString *imageViewID=[self getStoryBoardIdString];
            NSString *LabelID=[self getStoryBoardIdString];
            NSString *LabelID1=[self getStoryBoardIdString];
            
            [text appendFormat:@"<collectionViewCell opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" reuseIdentifier=\"%@\" id=\"%@\" customClass=\"%@\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"179\" height=\"225\"/>\n\
             <autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>\n\
             <view key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"179\" height=\"225\"/>\n\
             <autoresizingMask key=\"autoresizingMask\"/>\n\
             <subviews>\n\
             <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"4\" y=\"8\" width=\"171\" height=\"128\"/>\n\
             </imageView>\n\
             <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"68\" y=\"155\" width=\"42\" height=\"21\"/>\n\
             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
             <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
             <nil key=\"highlightedColor\"/>\n\
             </label>\n\
             <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"68\" y=\"190\" width=\"42\" height=\"21\"/>\n\
             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
             <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
             <nil key=\"highlightedColor\"/>\n\
             </label>\n\
             </subviews>\n\
             <color key=\"backgroundColor\" white=\"0.0\" alpha=\"0.0\" colorSpace=\"calibratedWhite\"/>\n\
             </view>\n\
             </collectionViewCell>\n",cells,idText,cells,imageViewID,LabelID,LabelID1];
        }
    }
    
    [text appendFormat:@"</cells>\n\
     </collectionView>\n\
     </subviews>\n\
     <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"calibratedWhite\"/>\n\
     <constraints>\n\
     <constraint firstItem=\"hB6-Qs-mJM\" firstAttribute=\"leading\" secondItem=\"D83-1j-lmx\" secondAttribute=\"leading\" id=\"2yv-3E-Rez\"/>\n\
     <constraint firstAttribute=\"trailing\" secondItem=\"hB6-Qs-mJM\" secondAttribute=\"trailing\" id=\"96b-4d-LF1\"/>\n\
     <constraint firstItem=\"4Vf-XF-v7h\" firstAttribute=\"top\" secondItem=\"hB6-Qs-mJM\" secondAttribute=\"bottom\" id=\"I41-ln-kzl\"/>\n\
     <constraint firstItem=\"hB6-Qs-mJM\" firstAttribute=\"top\" secondItem=\"7cz-NE-Ze6\" secondAttribute=\"bottom\" id=\"wPv-0k-7E7\"/>\n\
     </constraints>\n\
     </view>\n\
     <connections>\n\
     <outlet property=\"collectionView\" destination=\"hB6-Qs-mJM\" id=\"%@\"/>\n\
     </connections>\n\
     </viewController>\n\
     <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"dZO-Le-KF4\" sceneMemberID=\"firstResponder\"/>\n\
     </objects>\n\
     <point key=\"canvasLocation\" x=\"416\" y=\"662\"/>\n\
     </scene>\n\
     </scenes>\n\
     </document>",[self getStoryBoardIdString]];
    
    return text;
}

- (NSString *)ViewController:(NSString *)viewController TableViewCells:(NSArray *)tableviewCells{
    NSMutableString *text=[NSMutableString string];
    
    [text appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
     <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
     <dependencies>\n\
     <deployment identifier=\"iOS\"/>\n\
     <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
     </dependencies>\n\
     <scenes>\n\
     <!--View Controller-->\n\
     <scene sceneID=\"ln6-he-TvZ\">\n\
     <objects>\n"];
    
    
    if (viewController.length>0) {
        [text appendFormat:@"<viewController storyboardIdentifier=\"%@ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"%@ViewController\" sceneMemberID=\"viewController\">\n",viewController,viewController];
    }else{
        [text appendFormat:@"<viewController storyboardIdentifier=\"ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n"];
    }
    
    [text appendString:@"<layoutGuides>\n\
     <viewControllerLayoutGuide type=\"top\" id=\"Fs0-p9-OwV\"/>\n\
     <viewControllerLayoutGuide type=\"bottom\" id=\"JON-mD-ZcH\"/>\n\
     </layoutGuides>\n\
     <view key=\"view\" contentMode=\"scaleToFill\" id=\"1m3-F1-jrf\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
     <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
     <subviews>\n\
     <tableView clipsSubviews=\"YES\" contentMode=\"scaleToFill\" alwaysBounceVertical=\"YES\" dataMode=\"prototypes\" style=\"plain\" separatorStyle=\"default\" rowHeight=\"124\" sectionHeaderHeight=\"28\" sectionFooterHeight=\"28\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"AUd-uD-BAZ\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
     <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n"];
    
    if (tableviewCells.count>0) {
        [text appendString:@"\n<prototypes>\n"];
        for (NSString *cells in tableviewCells) {
            NSString *idText=[self getStoryBoardIdString];
            NSString *idText2=[self getStoryBoardIdString];
            [text appendFormat:@"<tableViewCell clipsSubviews=\"YES\" contentMode=\"scaleToFill\" selectionStyle=\"default\" indentationWidth=\"10\" reuseIdentifier=\"%@\" rowHeight=\"124\" id=\"%@\" customClass=\"%@\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"28\" width=\"600\" height=\"124\"/>\n\
             <autoresizingMask key=\"autoresizingMask\"/>\n\
             <tableViewCellContentView key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" tableViewCell=\"%@\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"123\"/>\n\
             <autoresizingMask key=\"autoresizingMask\"/>\n",cells,idText,cells,idText,idText2];
            
            NSString *imageViewID=[self getStoryBoardIdString];
            NSString *LabelID=[self getStoryBoardIdString];
            NSString *ButtonID=[self getStoryBoardIdString];
            NSString *TextFiledID=[self getStoryBoardIdString];
            
            [text appendFormat:@"<subviews>\n\
             <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"17\" y=\"8\" width=\"102\" height=\"107\"/>\n\
             </imageView>\n\
             <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"164\" y=\"51\" width=\"42\" height=\"21\"/>\n\
             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
             <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
             <nil key=\"highlightedColor\"/>\n\
             </label>\n\
             <button opaque=\"NO\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"center\" contentVerticalAlignment=\"center\" buttonType=\"roundedRect\" lineBreakMode=\"middleTruncation\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"506\" y=\"47\" width=\"46\" height=\"30\"/>\n\
             <state key=\"normal\" title=\"Button\"/>\n\
             </button>\n\
             <textField opaque=\"NO\" clipsSubviews=\"YES\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"left\" contentVerticalAlignment=\"center\" borderStyle=\"roundedRect\" textAlignment=\"natural\" minimumFontSize=\"17\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"252\" y=\"13\" width=\"97\" height=\"30\"/>\n\
             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"14\"/>\n\
             <textInputTraits key=\"textInputTraits\"/>\n\
             </textField>\n\
             </subviews>",imageViewID,LabelID,ButtonID,TextFiledID];
            
            [text appendString:@"</tableViewCellContentView>\n\
             </tableViewCell>\n"];
            
        }
        [text appendString:@"\n</prototypes>\n"];
    }
    
    [text appendFormat:@"</tableView>\n\
     </subviews>\n\
     <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n\
     <constraints>\n\
     <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"leading\" secondItem=\"1m3-F1-jrf\" secondAttribute=\"leading\" id=\"IFI-ix-5mE\"/>\n\
     <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"top\" secondItem=\"Fs0-p9-OwV\" secondAttribute=\"bottom\" id=\"ZBG-g6-JnN\"/>\n\
     <constraint firstItem=\"JON-mD-ZcH\" firstAttribute=\"top\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"bottom\" id=\"gtw-gO-Drr\"/>\n\
     <constraint firstAttribute=\"trailing\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"trailing\" id=\"rHu-tH-pGX\"/>\n\
     </constraints>\n\
     </view>\n\
     <connections>\n\
     <outlet property=\"tableView\" destination=\"AUd-uD-BAZ\" id=\"%@\"/>\n\
     </connections>\n\
     </viewController>\n\
     <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"J53-ai-Zgt\" userLabel=\"First Responder\" sceneMemberID=\"firstResponder\"/>\n\
     </objects>\n\
     <point key=\"canvasLocation\" x=\"413\" y=\"554\"/>\n\
     </scene>\n\
     </scenes>\n\
     </document>\n",[self getStoryBoardIdString]];
    return text;
}

- (NSString *)ViewController:(NSString *)viewController TableViewCells:(NSArray *)tableviewCells subTableCells:(NSArray *)subTableCellDic{
    NSMutableString *text=[NSMutableString string];
    
    [text appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n\
     <document type=\"com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB\" version=\"3.0\" toolsVersion=\"10116\" systemVersion=\"15A2301\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\">\n\
     <dependencies>\n\
     <deployment identifier=\"iOS\"/>\n\
     <plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"10085\"/>\n\
     </dependencies>\n\
     <scenes>\n\
     <!--View Controller-->\n\
     <scene sceneID=\"ln6-he-TvZ\">\n\
     <objects>\n"];
    
    
    if (viewController.length>0) {
        [text appendFormat:@"<viewController storyboardIdentifier=\"%@ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"%@ViewController\" sceneMemberID=\"viewController\">\n",viewController,viewController];
    }else{
        [text appendFormat:@"<viewController storyboardIdentifier=\"ViewController\" useStoryboardIdentifierAsRestorationIdentifier=\"YES\" id=\"VQU-UQ-5rH\" customClass=\"ViewController\" sceneMemberID=\"viewController\">\n"];
    }
    
    [text appendString:@"<layoutGuides>\n\
     <viewControllerLayoutGuide type=\"top\" id=\"Fs0-p9-OwV\"/>\n\
     <viewControllerLayoutGuide type=\"bottom\" id=\"JON-mD-ZcH\"/>\n\
     </layoutGuides>\n\
     <view key=\"view\" contentMode=\"scaleToFill\" id=\"1m3-F1-jrf\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"600\"/>\n\
     <autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>\n\
     <subviews>\n\
     <tableView clipsSubviews=\"YES\" contentMode=\"scaleToFill\" alwaysBounceVertical=\"YES\" dataMode=\"prototypes\" style=\"plain\" separatorStyle=\"default\" rowHeight=\"124\" sectionHeaderHeight=\"28\" sectionFooterHeight=\"28\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"AUd-uD-BAZ\">\n\
     <rect key=\"frame\" x=\"0.0\" y=\"20\" width=\"600\" height=\"580\"/>\n\
     <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n"];
    
    if (tableviewCells.count>0) {
        [text appendString:@"\n<prototypes>\n"];
        for (NSString *cells in tableviewCells) {
            NSString *idText=[self getStoryBoardIdString];
            NSString *idText2=[self getStoryBoardIdString];
            
            NSInteger cellHeight=124;
            
            [text appendFormat:@"<tableViewCell clipsSubviews=\"YES\" contentMode=\"scaleToFill\" selectionStyle=\"default\" indentationWidth=\"10\" reuseIdentifier=\"%@\" rowHeight=\"***&&&***\" id=\"%@\" customClass=\"%@\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"28\" width=\"600\" height=\"***&&&***\"/>\n\
             <autoresizingMask key=\"autoresizingMask\"/>\n\
             <tableViewCellContentView key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" tableViewCell=\"%@\" id=\"%@\">\n\
             <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"***&&&1***\"/>\n\
             <autoresizingMask key=\"autoresizingMask\"/>\n",cells,idText,cells,idText,idText2];
            
            NSString *imageViewID=[self getStoryBoardIdString];
            NSString *LabelID=[self getStoryBoardIdString];
            NSString *ButtonID=[self getStoryBoardIdString];
            NSString *TextFiledID=[self getStoryBoardIdString];
            
            NSString *subDicKey=@"";
            NSString *specialViewId=@"";
            
            for (NSDictionary *dic in subTableCellDic) {
                NSString *cellName=[cells stringByReplacingOccurrencesOfString:@"TableViewCell" withString:@""];
                NSDictionary *subDic=dic[cellName];
                
                if (subDic.count>0) {
                    cellHeight=0;
                    
                    subDicKey=[subDic allKeys][0];
                    if ([subDicKey isEqualToString:@"0"]) {
                        cellHeight=124;
                        
                        [text appendFormat:@"<subviews>\n\
                         <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                         <rect key=\"frame\" x=\"17\" y=\"8\" width=\"102\" height=\"107\"/>\n\
                         </imageView>\n\
                         <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                         <rect key=\"frame\" x=\"164\" y=\"51\" width=\"42\" height=\"21\"/>\n\
                         <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
                         <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
                         <nil key=\"highlightedColor\"/>\n\
                         </label>\n\
                         <button opaque=\"NO\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"center\" contentVerticalAlignment=\"center\" buttonType=\"roundedRect\" lineBreakMode=\"middleTruncation\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                         <rect key=\"frame\" x=\"506\" y=\"47\" width=\"46\" height=\"30\"/>\n\
                         <state key=\"normal\" title=\"Button\"/>\n\
                         </button>\n\
                         <textField opaque=\"NO\" clipsSubviews=\"YES\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"left\" contentVerticalAlignment=\"center\" borderStyle=\"roundedRect\" textAlignment=\"natural\" minimumFontSize=\"17\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                         <rect key=\"frame\" x=\"252\" y=\"13\" width=\"97\" height=\"30\"/>\n\
                         <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"14\"/>\n\
                         <textInputTraits key=\"textInputTraits\"/>\n\
                         </textField>\n\
                         </subviews>\n",imageViewID,LabelID,ButtonID,TextFiledID];
                        
                        NSString *tempCode=[text copy];
                        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"***&&&***" withString:[NSString stringWithFormat:@"%ld",cellHeight]];
                        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"***&&&1***" withString:[NSString stringWithFormat:@"%ld",(cellHeight-1)]];
                        [text setString:tempCode];
                        break;
                    }
                    else if ([subDicKey isEqualToString:@"1"]){
                        
                        NSArray *arrCells=subDic[@"1"];
                        
                        NSString *tableViewID=[self getStoryBoardIdString];
                        [text appendFormat:@"<subviews>\n\
                         <tableView clipsSubviews=\"YES\" contentMode=\"scaleToFill\" alwaysBounceVertical=\"YES\" dataMode=\"prototypes\" style=\"plain\" separatorStyle=\"default\" rowHeight=\"44\" sectionHeaderHeight=\"28\" sectionFooterHeight=\"28\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                         <rect key=\"frame\" x=\"20.0\" y=\"20.0\" width=\"560\" height=\"%ld\"/>\n\
                         <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n\
                         <prototypes>\n",tableViewID,124*arrCells.count+38];
                        
                        specialViewId=tableViewID;
                        
                        cellHeight+=(124*arrCells.count);
                        
                        for (NSString *subCell in arrCells) {
                            NSString *idText3=[self getStoryBoardIdString];
                            NSString *idText4=[self getStoryBoardIdString];
                            NSString *imageViewID_new=[self getStoryBoardIdString];
                            NSString *LabelID_new=[self getStoryBoardIdString];
                            NSString *ButtonID_new=[self getStoryBoardIdString];
                            NSString *TextFiledID_new=[self getStoryBoardIdString];
                            
                            [text appendFormat:@"<tableViewCell clipsSubviews=\"YES\" contentMode=\"scaleToFill\" selectionStyle=\"default\" indentationWidth=\"10\" reuseIdentifier=\"%@TableViewCell\" rowHeight=\"124\" id=\"%@\" customClass=\"%@TableViewCell\">\n\
                             <rect key=\"frame\" x=\"0.0\" y=\"28\" width=\"600\" height=\"124\"/>\n\
                             <autoresizingMask key=\"autoresizingMask\"/>\n\
                             <tableViewCellContentView key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" tableViewCell=\"%@\" id=\"%@\">\n\
                             <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"123\"/>\n\
                             <autoresizingMask key=\"autoresizingMask\"/>\n\
                             <subviews>\n\
                             <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                             <rect key=\"frame\" x=\"27\" y=\"10\" width=\"92\" height=\"97\"/>\n\
                             </imageView>\n\
                             <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                             <rect key=\"frame\" x=\"164\" y=\"51\" width=\"42\" height=\"21\"/>\n\
                             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
                             <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
                             <nil key=\"highlightedColor\"/>\n\
                             </label>\n\
                             <button opaque=\"NO\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"center\" contentVerticalAlignment=\"center\" buttonType=\"roundedRect\" lineBreakMode=\"middleTruncation\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                             <rect key=\"frame\" x=\"486\" y=\"57\" width=\"46\" height=\"30\"/>\n\
                             <state key=\"normal\" title=\"Button\"/>\n\
                             </button>\n\
                             <textField opaque=\"NO\" clipsSubviews=\"YES\" contentMode=\"scaleToFill\" fixedFrame=\"YES\" contentHorizontalAlignment=\"left\" contentVerticalAlignment=\"center\" borderStyle=\"roundedRect\" textAlignment=\"natural\" minimumFontSize=\"17\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                             <rect key=\"frame\" x=\"252\" y=\"13\" width=\"97\" height=\"30\"/>\n\
                             <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"14\"/>\n\
                             <textInputTraits key=\"textInputTraits\"/>\n\
                             </textField>\n\
                             </subviews>\n\
                             </tableViewCellContentView>\n\
                             </tableViewCell>\n",subCell,idText3,subCell,idText3,idText4,imageViewID_new,LabelID_new,ButtonID_new,TextFiledID_new];
                        }
                        [text appendFormat:@"</prototypes>\n\
                         </tableView>\n\
                         </subviews>\n\
                         <constraints>\n\
                         <constraint firstItem=\"%@\" firstAttribute=\"top\" secondItem=\"%@\" secondAttribute=\"top\" constant=\"20\" id=\"%@\"/>\n\
                         <constraint firstItem=\"%@\" firstAttribute=\"leading\" secondItem=\"%@\" secondAttribute=\"leading\" constant=\"20\" id=\"%@\"/>\n\
                         <constraint firstAttribute=\"trailing\" secondItem=\"%@\" secondAttribute=\"trailing\" constant=\"20\" id=\"%@\"/>\n\
                         <constraint firstAttribute=\"bottom\" secondItem=\"%@\" secondAttribute=\"bottom\" constant=\"20\" id=\"%@\"/>\n\
                         </constraints>\n",tableViewID,idText2,[self getStoryBoardIdString],tableViewID,idText2,[self getStoryBoardIdString],tableViewID,[self getStoryBoardIdString],tableViewID,[self getStoryBoardIdString]];
                        
                        NSString *tempCode=[text copy];
                        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"***&&&***" withString:[NSString stringWithFormat:@"%ld",cellHeight+38+40]];
                        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"***&&&1***" withString:[NSString stringWithFormat:@"%ld",(cellHeight)+38+40]];
                        [text setString:tempCode];
                        break;
                    }
                    else if ([subDicKey isEqualToString:@"2"]){
                        
                        NSArray *arrCells=subDic[@"2"];
                        
                        NSString *collectionId=[self getStoryBoardIdString];
                        NSString *dlowLayoutId=[self getStoryBoardIdString];
                        
                        NSInteger height=0;
                        if (arrCells.count%3==0) {
                            height=216*(arrCells.count/3);
                            cellHeight=height;
                        }else{
                            height=216*(arrCells.count/3)+216;
                            cellHeight=height;
                        }
                        height+=19;
                        height+=10;
                        
                        [text appendFormat:@"<subviews>\n\
                        <collectionView clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"scaleToFill\" dataMode=\"prototypes\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                        <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"600\" height=\"%ld\"/>\n\
                        <collectionViewFlowLayout key=\"collectionViewLayout\" minimumLineSpacing=\"10\" minimumInteritemSpacing=\"10\" id=\"%@\">\n\
                        <size key=\"itemSize\" width=\"167\" height=\"216\"/>\n\
                        <size key=\"headerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
                        <size key=\"footerReferenceSize\" width=\"0.0\" height=\"0.0\"/>\n\
                        <inset key=\"sectionInset\" minX=\"0.0\" minY=\"0.0\" maxX=\"0.0\" maxY=\"0.0\"/>\n\
                        </collectionViewFlowLayout>\n\
                         <cells>\n",collectionId,height,dlowLayoutId];
                        
                        specialViewId=collectionId;
                        
                        for (NSString *subCell in arrCells) {
                            NSString *idText5=[self getStoryBoardIdString];
                            NSString *imageViewID_new=[self getStoryBoardIdString];
                            NSString *LabelID_new1=[self getStoryBoardIdString];
                            NSString *LabelID_new2=[self getStoryBoardIdString];
                            [text appendFormat:@"<collectionViewCell opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\" reuseIdentifier=\"%@CollectionViewCell\" id=\"%@\" customClass=\"%@CollectionViewCell\">\n\
                            <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"167\" height=\"216\"/>\n\
                            <autoresizingMask key=\"autoresizingMask\" flexibleMaxX=\"YES\" flexibleMaxY=\"YES\"/>\n\
                            <view key=\"contentView\" opaque=\"NO\" clipsSubviews=\"YES\" multipleTouchEnabled=\"YES\" contentMode=\"center\">\n\
                            <rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"167\" height=\"216\"/>\n\
                            <autoresizingMask key=\"autoresizingMask\"/>\n\
                            <subviews>\n\
                            <imageView userInteractionEnabled=\"NO\" contentMode=\"scaleToFill\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                            <rect key=\"frame\" x=\"4\" y=\"8\" width=\"155\" height=\"128\"/>\n\
                            </imageView>\n\
                            <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                            <rect key=\"frame\" x=\"68\" y=\"155\" width=\"42\" height=\"21\"/>\n\
                            <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
                            <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
                            <nil key=\"highlightedColor\"/>\n\
                            </label>\n\
                            <label opaque=\"NO\" userInteractionEnabled=\"NO\" contentMode=\"left\" horizontalHuggingPriority=\"251\" verticalHuggingPriority=\"251\" fixedFrame=\"YES\" text=\"Label\" textAlignment=\"natural\" lineBreakMode=\"tailTruncation\" baselineAdjustment=\"alignBaselines\" adjustsFontSizeToFit=\"NO\" translatesAutoresizingMaskIntoConstraints=\"NO\" id=\"%@\">\n\
                            <rect key=\"frame\" x=\"68\" y=\"190\" width=\"42\" height=\"21\"/>\n\
                            <fontDescription key=\"fontDescription\" type=\"system\" pointSize=\"17\"/>\n\
                            <color key=\"textColor\" red=\"0.0\" green=\"0.0\" blue=\"0.0\" alpha=\"1\" colorSpace=\"calibratedRGB\"/>\n\
                            <nil key=\"highlightedColor\"/>\n\
                            </label>\n\
                            </subviews>\n\
                            <color key=\"backgroundColor\" white=\"0.0\" alpha=\"0.0\" colorSpace=\"calibratedWhite\"/>\n\
                            </view>\n\
                             </collectionViewCell>\n",subCell,idText5,subCell,imageViewID_new,LabelID_new1,LabelID_new2];
                        }
                        [text appendFormat:@"</cells>\n\
                         </collectionView>\n\
                         </subviews>\n\
                         <constraints>\n\
                         <constraint firstItem=\"%@\" firstAttribute=\"top\" secondItem=\"%@\" secondAttribute=\"top\" id=\"%@\"/>\n\
                         <constraint firstAttribute=\"bottom\" secondItem=\"%@\" secondAttribute=\"bottom\" id=\"%@\"/>\n\
                         <constraint firstItem=\"%@\" firstAttribute=\"leading\" secondItem=\"%@\" secondAttribute=\"leading\" id=\"%@\"/>\n\
                         <constraint firstAttribute=\"trailing\" secondItem=\"%@\" secondAttribute=\"trailing\" id=\"%@\"/>\n\
                         </constraints>\n",collectionId,idText2,[self getStoryBoardIdString],collectionId,[self getStoryBoardIdString],collectionId,idText2,[self getStoryBoardIdString],collectionId,[self getStoryBoardIdString]];
                        
                        NSString *tempCode=[text copy];
                        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"***&&&***" withString:[NSString stringWithFormat:@"%ld",cellHeight+20+10]];
                        tempCode=[tempCode stringByReplacingOccurrencesOfString:@"***&&&1***" withString:[NSString stringWithFormat:@"%ld",(cellHeight-1)+20+10]];
                        [text setString:tempCode];
                        break;
                    }
                }
            }
            [text appendString:@"</tableViewCellContentView>\n"];
            
            if ([subDicKey isEqualToString:@"1"]){
                if (specialViewId.length>0) {
                    [text appendFormat:@"<connections>\n\
                     <outlet property=\"tableView\" destination=\"%@\" id=\"%@\"/>\n\
                     </connections>\n",specialViewId,[self getStoryBoardIdString]];
                }
            }else if ([subDicKey isEqualToString:@"2"]){
                if (specialViewId.length>0) {
                    [text appendFormat:@"<connections>\n\
                     <outlet property=\"collectionView\" destination=\"%@\" id=\"%@\"/>\n\
                     </connections>\n",specialViewId,[self getStoryBoardIdString]];
                }
            }
            
            [text appendString:@"</tableViewCell>\n"];
            
        }
        [text appendString:@"\n</prototypes>\n"];
    }
    
    [text appendFormat:@"</tableView>\n\
     </subviews>\n\
     <color key=\"backgroundColor\" white=\"1\" alpha=\"1\" colorSpace=\"calibratedWhite\"/>\n\
     <constraints>\n\
     <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"leading\" secondItem=\"1m3-F1-jrf\" secondAttribute=\"leading\" id=\"IFI-ix-5mE\"/>\n\
     <constraint firstItem=\"AUd-uD-BAZ\" firstAttribute=\"top\" secondItem=\"Fs0-p9-OwV\" secondAttribute=\"bottom\" id=\"ZBG-g6-JnN\"/>\n\
     <constraint firstItem=\"JON-mD-ZcH\" firstAttribute=\"top\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"bottom\" id=\"gtw-gO-Drr\"/>\n\
     <constraint firstAttribute=\"trailing\" secondItem=\"AUd-uD-BAZ\" secondAttribute=\"trailing\" id=\"rHu-tH-pGX\"/>\n\
     </constraints>\n\
     </view>\n\
     <connections>\n\
     <outlet property=\"tableView\" destination=\"AUd-uD-BAZ\" id=\"%@\"/>\n\
     </connections>\n\
     </viewController>\n\
     <placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"J53-ai-Zgt\" userLabel=\"First Responder\" sceneMemberID=\"firstResponder\"/>\n\
     </objects>\n\
     <point key=\"canvasLocation\" x=\"413\" y=\"554\"/>\n\
     </scene>\n\
     </scenes>\n\
     </document>\n",[self getStoryBoardIdString]];
    return text;
}

- (NSString *)getStoryBoardIdString{
//    gSS-Oy-SNc
    NSMutableString *idText=[NSMutableString string];
    while (idText.length<3) {
        [idText appendString:[self getCharacter]];
    }
    [idText appendString:@"-"];
    while (idText.length<6) {
        [idText appendString:[self getCharacter]];
    }
    [idText appendString:@"-"];
    while (idText.length<10) {
        [idText appendString:[self getCharacter]];
    }
    return idText;
}
- (NSString *)getCharacter{
    NSInteger count=arc4random()%3+1;
    
    unichar ch;
    if (count==1) {
        ch='0'+arc4random()%10;
    }else if (count==2){
        ch='A'+arc4random()%26;
    }else {
        ch='a'+arc4random()%26;
    }
    return [NSString stringWithFormat:@"%C",ch];
}
@end
