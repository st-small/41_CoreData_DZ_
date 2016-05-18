//
//  SiSTeacherSelectionViewController.h
//  41_CoreData_DZ_
//
//  Created by Stas on 12.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "SiSTeacher.h"
#import "SiSStudent.h"
#import "SiSCourse.h"

@protocol SiSTeacherSelectionDelegate;

@interface SiSTeacherSelectionViewController : UITableViewController

@property (strong, nonatomic) NSArray* allTeachers;
@property (strong, nonatomic) SiSTeacher* selectedTeacher;
@property (strong, nonatomic) SiSCourse* course;

@property (strong, nonatomic) SiSTeacher <SiSTeacherSelectionDelegate>* delegate;

@end

@protocol SiSTeacherSelectionDelegate <NSObject>

@required

- (void) teacherSelectionDidEnd:(SiSTeacher*) teacherSelected;

@end
