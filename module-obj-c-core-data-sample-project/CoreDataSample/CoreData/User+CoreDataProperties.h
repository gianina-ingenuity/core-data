//
//  User+CoreDataProperties.h
//  CoreDataSample
//
//  Created by Jason Jon E. Carreos on 08/08/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *birthDate;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) Hobby *hobby;

@end

NS_ASSUME_NONNULL_END
