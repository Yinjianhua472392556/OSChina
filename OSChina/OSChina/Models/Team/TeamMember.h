//
//  TeamMember.h
//  OSChina
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OSCBaseObject.h"

@interface TeamMember : OSCBaseObject

@property (nonatomic, assign) int memberID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *oscName;
@property (nonatomic, strong) NSURL *portraitURL;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *teamJob;
@property (nonatomic, assign) int teamRole;
@property (nonatomic, strong) NSURL *space;
@property (nonatomic, copy) NSString *joinTime;
@property (nonatomic, copy) NSString *location;

- (instancetype)initWithCollaboratorXML:(ONOXMLElement *)xml; // //协助者



@end
