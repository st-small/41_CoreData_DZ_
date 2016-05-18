//
//  SiSDetailsTableViewController.m
//  41_CoreData_DZ_
//
//  Created by Stas on 10.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSDetailsTableViewController.h"

@interface SiSDetailsTableViewController ()

@end

@implementation SiSDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ====================================
    // ======== NAVIGATION BUTTONS ========
    // ====================================
    
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    // ^^^^^^^ NAVIGATION BUTTONS ^^^^^^^^^
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    
}


#pragma mark - === ACTIONS ===

- (void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
}


#pragma mark - === UITableViewDataSource ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionsArray count];
}

@end
