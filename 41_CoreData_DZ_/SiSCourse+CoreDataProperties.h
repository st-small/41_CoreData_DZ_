//
//  SiSCourse+CoreDataProperties.h
//  41_CoreData_DZ_
//
//  Created by Stas on 12.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SiSCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiSCourse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *industry;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSSet<SiSStudent *> *student;
@property (nullable, nonatomic, retain) SiSTeacher *teacher;

@end

@interface SiSCourse (CoreDataGeneratedAccessors)

- (void)addStudentObject:(SiSStudent *)value;
- (void)removeStudentObject:(SiSStudent *)value;
- (void)addStudent:(NSSet<SiSStudent *> *)values;
- (void)removeStudent:(NSSet<SiSStudent *> *)values;
- (void)addTeacherObject:(SiSTeacher *)value;
- (void)removeTeacherObject:(SiSTeacher *)value;

@end

NS_ASSUME_NONNULL_END
