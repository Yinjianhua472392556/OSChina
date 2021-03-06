//
//  TeamMember.m
//  OSChina
//
//  Created by apple on 16/3/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TeamMember.h"

@implementation TeamMember

- (instancetype)initWithXML:(ONOXMLElement *)xml {
    if (self = [super init]) {
        _memberID    = [[[xml firstChildWithTag:@"id"] numberValue] intValue];
        _name        = [[xml firstChildWithTag:@"name"] stringValue];
        _oscName     = [[xml firstChildWithTag:@"oscName"] stringValue];
        _portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:@"portrait"] stringValue]];
        _gender      = [[xml firstChildWithTag:@"gender"] stringValue];
        _email       = [[xml firstChildWithTag:@"teamEmail"] stringValue];
        _telephone   = [[xml firstChildWithTag:@"teamTelephone"] stringValue];
        _teamJob     = [[xml firstChildWithTag:@"teamJob"] stringValue];
        _teamRole    = [[[xml firstChildWithTag:@"teamRole"] numberValue] intValue];
        _space       = [NSURL URLWithString:[[xml firstChildWithTag:@"space"] stringValue]];
        _joinTime    = [[xml firstChildWithTag:@"joinTime"] stringValue];
        _location    = [[xml firstChildWithTag:@"location"] stringValue];

    }
    return self;
}

- (instancetype)initWithCollaboratorXML:(ONOXMLElement *)xml {

    if (self = [super init]) {
        _memberID    = [[[xml firstChildWithTag:@"user"] numberValue] intValue];
        _name        = [[xml firstChildWithTag:@"name"] stringValue];
        _portraitURL = [NSURL URLWithString:[[xml firstChildWithTag:@"portrait"] stringValue]];

    }
    return self;
}

@end
