//
//  SiSStudentSelectionViewController.m
//  41_CoreData_DZ_
//
//  Created by Stas on 11.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSStudentSelectionViewController.h"

@interface SiSStudentSelectionViewController ()

@property (strong, nonatomic) NSMutableArray* checkedIndexPathes;

@end

@implementation SiSStudentSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)dealloc {
    
    [self.delegate studentsSelectionDidEnd:self.selectedStudents];
}

#pragma mark - === Actions ===

- (void) actionDone:(UIBarButtonItem*) sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - === UITableViewDataSource ===

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allStudents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    SiSStudent* student = [self.allStudents objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if ([self.course.student containsObject:student]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    return cell;
}

#pragma mark - === UITableViewDelegate ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // ------ CHECKING BOX HANDLE ------
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SiSStudent* student = [self.allStudents objectAtIndex:indexPath.row];
    
    // IF CLICKED STUDENT WAS ENROLLED TO COURSE - REMOVE THIS STUDENT FROM COURSE
    // ELSE IF CLICKED STUDENT WAS NOT ENROLLED - ADD THIS STUDENT TO COURSE
    
    if ([self.course.student containsObject:student]) {
        [self.course removeStudentObject:student];
    } else {
        [self.course addStudentObject:student];
    }
    
    self.selectedStudents = [self.course.student allObjects];
    [self.tableView reloadData];
    
}

@end
