//
//  SiSTeacher+CoreDataProperties.h
//  41_CoreData_DZ_
//
//  Created by Stas on 12.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SiSTeacher.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiSTeacher (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<SiSCourse *> *course;

@end

@interface SiSTeacher (CoreDataGeneratedAccessors)

- (void)addCourseObject:(SiSCourse *)value;
- (void)removeCourseObject:(SiSCourse *)value;
- (void)addCourse:(NSSet<SiSCourse *> *)values;
- (void)removeCourse:(NSSet<SiSCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
