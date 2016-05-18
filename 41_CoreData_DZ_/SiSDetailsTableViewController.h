//
//  SiSDetailsTableViewController.h
//  41_CoreData_DZ_
//
//  Created by Stas on 10.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiSDetailsTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSArray* labels;
@property (strong, nonatomic) NSArray* placeholders;
@property (strong, nonatomic) NSMutableArray* textFields;

@property (strong, nonatomic) NSArray* sectionsArray;
@property (strong, nonatomic) NSArray* sectionsInfos;

@end
