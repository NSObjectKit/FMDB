//
//  ViewController.m
//  SqliteDemo
//
//  Created by Vanke on 2017/12/26.
//  Copyright © 2017年 Vanke. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "FMDB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //建表
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@", cachesDir);
    
    NSString *dbpath = [cachesDir stringByAppendingPathComponent:@"demo.db"];
    NSFileManager *file = [NSFileManager defaultManager];
    [file removeItemAtPath:dbpath error:NULL];
    
    FMDatabase *dataBase = [FMDatabase databaseWithPath:dbpath];
    
    [dataBase open];
    
    [dataBase executeUpdate:@"create table if not exists PERSON (id integer PRIMARY KEY, age integer, name text)"];
    
    [dataBase executeUpdate:@"create table if not exists CAROWNER (id text PRIMARY KEY, personID integer, carID integer)"];

   [dataBase executeUpdate:@"create table if not exists CAR (id integer PRIMARY KEY, price integer, name text)"];
    
    
    Car *car0 = [Car new];
    car0.Id = rand();
    car0.price = 1000002;
    car0.name = @"bz";
    
    Car *car1 = [Car new];
    car1.Id = rand();
    car1.price = 10003003;
    car1.name = @"bm";
    
    Car *car2 = [Car new];
    car2.Id = rand();
    car2.price = 1000004;
    car2.name = @"fll";
    
    Car *car3 = [Car new];
    car3.Id = rand();
    car3.price = 1030000;
    car3.name = @"at";
    
    Car *car4 = [Car new];
    car4.Id = rand();
    car4.price = 1000030;
    car4.name = @"bz";
    NSArray *cars = @[car0, car1, car2, car3, car4];
    //person car person-car
    

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
    __block BOOL result;
    [queue inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        for (Car *car in cars) {
           result = [db executeUpdate:@"INSERT INTO CAR (id, price, name) VALUES (?, ?, ?)", @(car.Id), @(car.price), car.name];
        }
        [db commit];
        if (!result) [db rollback];
    }];

    
    Person *p = [Person new];
    p.userId = rand();
    p.name = @"xiaoming";
    p.carArray = @[car2, car4];
    p.age = 32;
    NSLog(@"%d", p.userId);
    [dataBase executeUpdate:@"INSERT INTO PERSON (id, age, name) VALUES (?, ?, ?)", @(p.userId), @(p.age), p.name];
    
    for (Car *car in p.carArray) {
        [dataBase executeUpdate:@"INSERT INTO CAROWNER (id, personID, carID) VALUES (?, ?, ?)", [NSString stringWithFormat:@"%@%@", @(p.userId), @(car.Id)], @(p.userId), @(car.Id)];
    }

    
    
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *sql = @"select PERSON.name pname, \
        PERSON.id pid, PERSON.age, CAR.* from CAROWNER \
        inner join PERSON ON CAROWNER.personID = PERSON.id \
        inner join CAR ON CAROWNER.carID = CAR.ID \
        where CAROWNER.personID = ?";
        
        FMResultSet *resultSet = [dataBase executeQuery:sql, @(p.userId)];
       
        while ([resultSet next]) {
            
            [resultSet.columnNameToIndexMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//                NSLog(@"%@,%@", key, obj);
                id  a = [resultSet objectForColumn:key];
                NSLog(@"%@-------%@", key, a);
               
            }];
             NSLog(@"================");
        }
    });

    
}





@end
