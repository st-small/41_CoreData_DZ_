//
//  SiSStudentSelectionViewController.h
//  41_CoreData_DZ_
//
//  Created by Stas on 11.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "SiSStudent.h"
#import "SiSCourse.h"

@protocol SiSStudentSelectionDelegate;

@interface SiSStudentSelectionViewController : UITableViewController

@property (strong, nonatomic) NSArray* selectedStudents;

@property (strong, nonatomic) NSArray* allStudents;

@property (strong, nonatomic) SiSCourse* course;

@property (strong, nonatomic) id <SiSStudentSelectionDelegate> delegate;

@end

@protocol SiSStudentSelectionDelegate <NSObject>

@required

- (void) studentsSelectionDidEnd:(NSArray*) studentsSelected;

@end
