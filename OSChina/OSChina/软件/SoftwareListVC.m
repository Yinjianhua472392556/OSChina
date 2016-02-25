//
//  SoftwareListVC.m
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SoftwareListVC.h"
#import "OSCSoftware.h"
#import "SoftwareCell.h"


static NSString *kSoftwareCellID = @"SoftwareCell";

@interface SoftwareListVC ()
@property (nonatomic, strong) NSMutableDictionary *offscreenCells;
@end

@implementation SoftwareListVC

- (instancetype)initWithSoftwaresType:(SoftwaresType)softwareType {

    self = [super init];
    if (self) {
        NSString *searchTag;
        switch (softwareType) {
            case SoftwaresTypeRecommended: {
                searchTag = @"recommend";
                break;
            }
            case SoftwaresTypeNewest: {
                searchTag = @"time";
                break;
            }
            case SoftwaresTypeHottest: {
                searchTag = @"view";
                break;
            }
            case SoftwaresTypeCN: {
                searchTag = @"list_cn";
                break;
            }
        }
        self.generateURL =  ^NSString *(NSUInteger page){
        
            return [NSString stringWithFormat:@"%@%@?searchTag=%@&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_SOFTWARE_LIST,searchTag,page,OSCAPI_SUFFIX];
        };
        
        self.objClass = [OSCSoftware class];
    }
    return self;
}


- (instancetype)initWithSearchTag:(int)searchTag {

    if (self = [super init]) {
        self.generateURL = ^NSString *(NSUInteger page) {
            return [NSString stringWithFormat:@"%@%@?searchTag=%d&pageIndex=%lu&%@",OSCAPI_PREFIX,OSCAPI_SOFTWARETAG_LIST,searchTag,page,OSCAPI_SUFFIX];
        };
        self.objClass = [OSCSoftware class];
    }
    return self;
}

- (NSArray *)parseXML:(ONOXMLDocument *)xml {

    return [[xml.rootElement firstChildWithTag:@"softwares"] childrenWithTag:@"software"];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.tableView registerClass:[SoftwareCell class] forCellReuseIdentifier:kSoftwareCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SoftwareCell *cell = [tableView dequeueReusableCellWithIdentifier:kSoftwareCellID forIndexPath:indexPath];
    OSCSoftware *software = self.objects[indexPath.row];
    
    cell.backgroundColor= [UIColor themeColor];
    cell.nameLabel.text = software.name;
    cell.descriptionLabel.text = software.softwareDescription;
    cell.nameLabel.textColor = [UIColor titleColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    OSCSoftware *software = self.objects[indexPath.row];
    NSString *reuseIdentifier = kSoftwareCellID;
    SoftwareCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[SoftwareCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    cell.nameLabel.text = software.name;
    cell.descriptionLabel.text = software.softwareDescription;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 10;
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - 懒加载
- (NSMutableDictionary *)offscreenCells {

    if (_offscreenCells == nil) {
        _offscreenCells = [NSMutableDictionary dictionary];
    }
    return _offscreenCells;
}
@end
