//
//  SiSTeacherViewController.m
//  41_CoreData_DZ_
//
//  Created by Stas on 12.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSAddStudentViewController.h"
#import "SiSTeacher.h"
#import "SiSDataManager.h"
#import "SiSTeacherViewController.h"

@interface SiSTeacherViewController ()

@end

@implementation SiSTeacherViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Преподаватели";
    
    UIBarButtonItem* clearBase = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                  target:self
                                  action:@selector(actionClear:)];
    
    UIBarButtonItem* addingTeachers = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                      target:self
                                      action:@selector(addTeacher:)];
    
    
    self.navigationItem.rightBarButtonItems = @[clearBase, addingTeachers];
}

- (void) dealloc {
    
    [[SiSDataManager sharedManager] saveContext];
}

#pragma mark - === ACTIONS ===

- (void) actionClear:(UIBarButtonItem*) sender {
    
    [[SiSDataManager sharedManager] clearDataBaseWithName:@"SiSTeacher"];
}

- (void)addTeacher:(id)sender {
    
    //SiSTeacher* teacher = [[SiSDataManager sharedManager] addRandomTeacher];
    //    SiSAddStudentViewController* vc = [[SiSAddStudentViewController alloc] init];
    //    vc.student = student;
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"SiSCourse"
                                                   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor* subjectDescriptor = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];
    [fetchRequest setSortDescriptors:@[nameDescriptor, subjectDescriptor]];
    
    NSFetchedResultsController* aFetchResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:@"subject"
                                                   cacheName:nil];
    
    aFetchResultsController.delegate = self;
    self.fetchedResultsController = aFetchResultsController;
    
    NSError* error = nil;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
    
    //FETCH FOR TEACHERS
    
//    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription* description = [NSEntityDescription entityForName:@"SiSTeacher"
//                                                   inManagedObjectContext:self.managedObjectContext];
//    [fetchRequest setEntity:description];
//    
//    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
//    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
//    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
//    
//    NSFetchedResultsController* aFetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                                              managedObjectContext:self.managedObjectContext
//                                                                                                sectionNameKeyPath:nil
//                                                                                                         cacheName:nil];
//    
//    aFetchResultsController.delegate = self;
//    self.fetchedResultsController = aFetchResultsController;
//    
//    NSError* error = nil;
//    
//    if (![self.fetchedResultsController performFetch:&error]) {
//        
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _fetchedResultsController;
}

#pragma mark - UITableView DataSource

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (void) configureCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    
    SiSCourse* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SiSTeacher* teacher = course.teacher;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Преподает %d курс(-ов)", [teacher.course count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //CONFIGURE CELL FOR FWTCHING TEACHERS
//    SiSTeacher* teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}






@end
