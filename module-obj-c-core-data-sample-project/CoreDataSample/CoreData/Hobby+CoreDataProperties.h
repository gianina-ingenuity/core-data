//
//  Hobby+CoreDataProperties.h
//  CoreDataSample
//
//  Created by Jason Jon E. Carreos on 08/08/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Hobby.h"

NS_ASSUME_NONNULL_BEGIN

@interface Hobby (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<User *> *users;

@end

@interface Hobby (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet<User *> *)values;
- (void)removeUsers:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
