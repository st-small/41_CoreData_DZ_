//
//  SiSCoreDataViewControllerTableViewController.h
//  41_CoreData_DZ_
//
//  Created by Stas on 05.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SiSDataManager.h"

@interface SiSCoreDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

- (void) configureCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath;

@end
