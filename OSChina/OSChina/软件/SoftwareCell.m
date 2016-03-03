//
//  SoftwareCell.m
//  OSChina
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SoftwareCell.h"
#import "UIColor+Util.h"

@interface SoftwareCell()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation SoftwareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor themeColor];
        [self initSubviews];
    }
    return self;
}


- (void)initSubviews {

    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];

    _descriptionLabel = [UILabel new];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.font = [UIFont systemFontOfSize:13];
    _descriptionLabel.textColor = [UIColor colorWithHex:0x4F4F4F];
    [self.contentView addSubview:self.descriptionLabel];

}

//- (void)setLayout {
//
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(8);
//        make.right.equalTo(self.contentView.mas_right).offset(8);
//        make.top.equalTo(self.contentView.mas_top).offset(8);
//    }];
//    
//    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
//        make.left.equalTo(self.nameLabel.mas_left);
//        make.right.equalTo(self.nameLabel.mas_right);
//    }];
//}

- (void)updateConstraints {

    if (!self.didSetupConstraints) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(8);
            make.right.equalTo(self.contentView.mas_right).offset(-8);
            make.top.equalTo(self.contentView.mas_top).offset(8);
        }];
        
        [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.nameLabel.mas_left);
            make.right.equalTo(self.nameLabel.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-8);
        }];
        
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
}
@end
