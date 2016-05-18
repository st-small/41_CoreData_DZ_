//
//  SiSStudent+CoreDataProperties.h
//  41_CoreData_DZ_
//
//  Created by Stas on 12.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SiSStudent.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiSStudent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eMail;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<SiSCourse *> *courses;

@end

@interface SiSStudent (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(SiSCourse *)value;
- (void)removeCoursesObject:(SiSCourse *)value;
- (void)addCourses:(NSSet<SiSCourse *> *)values;
- (void)removeCourses:(NSSet<SiSCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
