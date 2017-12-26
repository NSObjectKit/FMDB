//
//  Person.h
//  SqliteDemo
//
//  Created by Vanke on 2017/12/26.
//  Copyright © 2017年 Vanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int age;

@property (nonatomic, copy) NSArray *carArray;

@property (nonatomic, assign) int userId;


@end
