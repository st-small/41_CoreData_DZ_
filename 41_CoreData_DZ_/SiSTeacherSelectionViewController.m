//
//  SiSTeacherSelectionViewController.m
//  41_CoreData_DZ_
//
//  Created by Stas on 12.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSTeacherSelectionViewController.h"

@interface SiSTeacherSelectionViewController ()

@property (strong, nonatomic) NSIndexPath* checkedIndexPath;

@end

@implementation SiSTeacherSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:@selector(actionDone:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
        
}

- (void)dealloc {
    
    [self.delegate teacherSelectionDidEnd:self.selectedTeacher];
}

#pragma mark - === Actions ===

- (void) actionDone:(UIBarButtonItem*) sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - === UITableViewDataSource ===

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allTeachers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    SiSTeacher* teacher = [self.allTeachers objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([self.course.teacher isEqual:teacher]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
    
    return cell;
}

#pragma mark - === UITableViewDelegate ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SiSTeacher* teacher = [self.allTeachers objectAtIndex:indexPath.row];
    
    if ([self.course.teacher isEqual:teacher]) {
        [self.course.teacher removeCourseObject:self.course];
    } else {
        [self.course.teacher addCourseObject:self.course];
    }
    
    [self.tableView reloadData];
    
}



@end
