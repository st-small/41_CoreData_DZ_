//
//  SiSCoursesViewController.m
//  41_CoreData_DZ_
//
//  Created by Stas on 07.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSCoursesViewController.h"
#import "SiSAddCourseViewController.h"
#import "SiSCourse.h"
#import "SiSDataManager.h"

@interface SiSCoursesViewController ()

@end

@implementation SiSCoursesViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Курсы";
    
    UIBarButtonItem* clearBase = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                        target:self
                                                        action:@selector(actionClear:)];
    
    
    UIBarButtonItem* addingCourses = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(actionAdd:)];

    
    self.navigationItem.rightBarButtonItems = @[clearBase, addingCourses];
    
    
}

#pragma mark - === ACTIONS ===

- (void) actionAdd:(UIBarButtonItem*) sender {
    
    [[SiSDataManager sharedManager] generateAndAddStudentBatch];
    
}

- (void) actionClear:(UIBarButtonItem*) sender {
    
    [[SiSDataManager sharedManager] clearDataBaseWithName:@"SiSCourse"];
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
}

#pragma mark - UITableView DataSource

- (void) configureCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    
    SiSCourse* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = course.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%u students", [course.student count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

#pragma mark - === UITableViewDelegate ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SiSCourse* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    SiSAddCourseViewController* vc = [[SiSAddCourseViewController alloc] init];
    
    vc.course = course;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
