//
//  SiSAddCourseViewController.h
//  41_CoreData_DZ_
//
//  Created by Stas on 10.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSStudent.h"
#import "SiSCourse.h"
#import "SiSTeacher.h"
#import "SiSDetailsTableViewController.h"

@interface SiSAddCourseViewController : SiSDetailsTableViewController

@property (strong, nonatomic) SiSCourse* course;

@end
