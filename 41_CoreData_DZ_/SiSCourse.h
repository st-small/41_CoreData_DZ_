//
//  SiSCourse.h
//  41_CoreData_DZ_
//
//  Created by Stas on 07.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SiSObject.h"

@class SiSStudent, SiSTeacher;

NS_ASSUME_NONNULL_BEGIN

@interface SiSCourse : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "SiSCourse+CoreDataProperties.h"
