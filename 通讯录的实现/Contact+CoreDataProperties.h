//
//  Contact+CoreDataProperties.h
//  01-通讯录的实现
//
//  Created by panxubin on 16/9/26.
//  Copyright © 2016年 xiaoming. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *namePinYin;
@property (nullable, nonatomic, retain) NSString *phoneNum;
@property (nullable, nonatomic, retain) NSString *sectionName;

@end

NS_ASSUME_NONNULL_END
