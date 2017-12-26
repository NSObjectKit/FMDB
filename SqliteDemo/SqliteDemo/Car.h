//
//  Car.h
//  SqliteDemo
//
//  Created by Vanke on 2017/12/26.
//  Copyright © 2017年 Vanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject


@property (nonatomic, strong) NSString *name;

//单位分
@property (nonatomic, assign) int price;

@property (nonatomic, assign) int Id;

@end
