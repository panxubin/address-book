//
//  HMCoreDataStackManager.h
//  手动创建CoreDataStack
//
//  Created by 潘旭滨 on 16/9/25.
//  Copyright © 2016年 潘旭滨 All rights reserved.
//

#import <Foundation/Foundation.h>

//导入CoreData框架
#import <CoreData/CoreData.h>

#define kXBCoreDataStackManager [XBCoreDataStackManager shareInstance]

//kHMCoreDataStackManager

@interface XBCoreDataStackManager : NSObject

//单利实现
+ (XBCoreDataStackManager *)shareInstance;

//管理对象上下文
@property(nonatomic,strong)NSManagedObjectContext *managedObjectContext;

//模型对象
@property(nonatomic,strong)NSManagedObjectModel *managedObjectModel;


//存储调度器
@property(nonatomic,strong)NSPersistentStoreCoordinator *persistentStoreCoordinator;


//保存
- (void)save;

@end
