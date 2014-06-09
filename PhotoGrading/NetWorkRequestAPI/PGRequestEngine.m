//
//  PGRequestEngine.m
//  PhotoGrading
//
//  Created by yang donglin on 14-2-26.
//  Copyright (c) 2014年 杨東霖. All rights reserved.
//

#import "PGRequestEngine.h"

@implementation PGRequestEngine

+ (id)shareInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithHostName:PG_API_SERVER customHeaderFields:NULL]; // or some other init method
    });
    return _sharedObject;
}

@end
