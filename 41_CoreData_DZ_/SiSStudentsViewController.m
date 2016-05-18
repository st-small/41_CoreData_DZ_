//
//  SiSStudentsViewController.m
//  41_CoreData_DZ_
//
//  Created by Stas on 05.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSStudentsViewController.h"
#import "SiSAddStudentViewController.h"
#import "SiSStudent.h"
#import "SiSDataManager.h"

@interface SiSStudentsViewController ()

@end

@implementation SiSStudentsViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Студенты";
    
    UIBarButtonItem* clearBase = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                  target:self
                                  action:@selector(actionClear:)];
    
    UIBarButtonItem* addingCourses = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(addStudent:)];
    
    
    self.navigationItem.rightBarButtonItems = @[clearBase, addingCourses];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"SiSStudent"
                                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController* aFetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                              managedObjectContext:self.managedObjectContext
                                                                                                sectionNameKeyPath:nil
                                                                                                         cacheName:nil];
    
    aFetchResultsController.delegate = self;
    self.fetchedResultsController = aFetchResultsController;
    
    NSError* error = nil;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableView DataSource

- (void) configureCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    
    SiSStudent* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.detailTextLabel.text = student.eMail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiSStudent* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SiSAddStudentViewController* vc = [[SiSAddStudentViewController alloc] init];
    vc.student = student;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - === ACTIONS ===

- (void) actionClear:(UIBarButtonItem*) sender {
    
    [[SiSDataManager sharedManager] clearDataBaseWithName:@"SiSStudent"];
}

- (void)addStudent:(id)sender {
    
    SiSStudent* student = [[SiSDataManager sharedManager] addRandomStudent];
    SiSAddStudentViewController* vc = [[SiSAddStudentViewController alloc] init];
    vc.student = student;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
