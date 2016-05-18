//
//  SiSAddCourseViewController.m
//  41_CoreData_DZ_
//
//  Created by Stas on 10.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSAddCourseViewController.h"
#import "SiSDataManager.h"
#import "SiSAddStudentViewController.h"
#import "SiSTeacherSelectionViewController.h"
#import "SiSStudentSelectionViewController.h"

@interface SiSAddCourseViewController () <SiSStudentSelectionDelegate, SiSTeacherSelectionDelegate>

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* subjectTextField;
@property (strong, nonatomic) UITextField* departmentTextField;
@property (strong, nonatomic) UITextField* teacherTextField;

@property (strong, nonatomic) NSArray* studentsAtCourse;
@property (strong, nonatomic) SiSTeacher* teacherAtCourse;
@property (assign, nonatomic) BOOL isEditMode;

@end

typedef enum {
    
    SiSTextFieldTypeName,
    SiSTextFieldTypeSubject,
    SiSTextFieldTypeIndustry,
    SiSTextFieldTypeTeacher
    
} SiSTextFieldType;


typedef enum {
    
    SiSSectionsTypeCourseInfo,
    SiSSectionsTypeStudentsArray
    
} SiSSectionsType;

@implementation SiSAddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.studentsAtCourse = [self.course.student allObjects];
    
    self.labels = @[@"Курс:", @"Предмет:", @"Отрасль:", @"Преподаватель:"];
    self.placeholders = @[@"Название курса", @"Предмет курса", @"Отрасль", @"Выбрать преподавателя"];
    self.sectionsInfos = @[@"Информация о курсе:", @"Студенты курса:"];
    self.sectionsArray = @[self.labels, self.studentsAtCourse];
    self.textFields = [NSMutableArray array];
}

#pragma mark - === HELPER METHODS ===

- (void) showControllrer:(UIViewController*) vc inPopoverFromSender:(id) sender {
    
    if (!sender) {
        return;
    }
    
    [self presentViewController:vc
                       animated:YES completion:^{
                           
                       }];
    
    CGRect fieldRect;
    
    if ([sender isKindOfClass:[UITextField class]]) {
        fieldRect = [self.view convertRect:[(UITextField*) sender frame] fromView:(UITextField*) sender];
        
    } else if ([sender isKindOfClass:[UITableViewCell class]]) {
        fieldRect = [self.view convertRect:[(UITableViewCell*) sender frame] fromView:(UITableViewCell*) sender];
    }
    
    UIPopoverPresentationController* popover = [vc popoverPresentationController];
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popover.barButtonItem = sender;
    
//    [popover presentPopoverFromRect:fieldRect
//                             inView:self.view
//           permittedArrowDirections:UIPopoverArrowDirectionAny
//                           animated:YES];
    
}

- (void) showControllerAsModal:(UIViewController*) vc {
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - === ACTIONS ===

- (void) actionInfoChanged:(UITextField*) sender {
    
    switch (sender.tag) {
        case SiSTextFieldTypeName:
            self.course.name = sender.text;
            break;
            
        case SiSTextFieldTypeSubject:
            self.course.subject = sender.text;
            break;
            
        case SiSTextFieldTypeIndustry:
            self.course.industry = sender.text;
            break;
            
        case SiSTextFieldTypeTeacher:
            
            break;
            
        default:
            break;
    }
    
}

- (void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
        self.isEditMode = YES;
        [self.nameTextField becomeFirstResponder];
    } else {
        
        for (UITextField* tf in self.textFields) {
            [tf resignFirstResponder];
        }
        
        self.isEditMode = NO;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
}

#pragma mark - === UITableViewDataSource ===


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.sectionsInfos objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == SiSSectionsTypeCourseInfo) {
        
        return [self.labels count];
    }
    
    return [self.studentsAtCourse count] + 1; // ADDITIONAL 1 ROW FOR BUTTON "SUBMIT NEW STUDENT FOR COURSE"
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* infoCellsIdentifier = @"infoCell";
    static NSString* addStudentIdentifier = @"addStudentCell";
    static NSString* studentCellsIdentifier = @"studentCell";
    
    
    if (indexPath.section == SiSSectionsTypeCourseInfo) { // COURSE INFO SECION
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:infoCellsIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCellsIdentifier];
        }
        
        cell.textLabel.text = [self.labels objectAtIndex:indexPath.row];
        
        // TEXT FIELDS FOR EDITING COURSE INFO
        
        CGRect cellRect = cell.bounds;
        CGRect tfRect = CGRectMake(cellRect.origin.x+ 150, cellRect.origin.y + 5, cellRect.size.width - 160, cellRect.size.height - 10);
        
        UITextField* tf = [[UITextField alloc] initWithFrame:tfRect];
        [tf setBorderStyle:UITextBorderStyleRoundedRect];
        
        [tf setSpellCheckingType:UITextSpellCheckingTypeNo];
        [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
        [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [tf setKeyboardType:UIKeyboardTypeDefault];
        
        NSString* tfText = nil;
        
        switch (indexPath.row) {
            case SiSTextFieldTypeName:
                tfText = self.course.name;
                [tf setReturnKeyType:UIReturnKeyNext];
                tf.tag = SiSTextFieldTypeName;
                
                self.nameTextField = tf;
                self.nameTextField.delegate = self;
                break;
                
            case SiSTextFieldTypeSubject:
                tfText = self.course.subject;
                [tf setReturnKeyType:UIReturnKeyNext];
                tf.tag = SiSTextFieldTypeSubject;
                
                self.subjectTextField = tf;
                self.subjectTextField.delegate = self;
                break;
                
            case SiSTextFieldTypeIndustry:
                tfText = self.course.industry;
                [tf setReturnKeyType:UIReturnKeyNext];
                tf.tag = SiSTextFieldTypeIndustry;
                
                self.departmentTextField = tf;
                self.departmentTextField.delegate = self;
                break;
                
            case SiSTextFieldTypeTeacher:
                
                if (self.course.teacher) {
                    tfText = [NSString stringWithFormat:@"%@ %@", self.course.teacher.firstName, self.course.teacher.lastName];
                }
                
                [tf setReturnKeyType:UIReturnKeyDone];
                tf.tag = SiSTextFieldTypeTeacher;
                
                self.teacherTextField = tf;
                self.teacherTextField.delegate = self;
                break;
                
            default:
                break;
        }
        
        tf.text = tfText;
        tf.placeholder = [self.placeholders objectAtIndex:indexPath.row];
        
        [tf addTarget:self action:@selector(actionInfoChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [cell addSubview:tf];
        
        if (![self.textFields containsObject:tf]) {
            
            [self.textFields addObject:tf];
        }
        return cell;
    }
    
    if (indexPath.row == 0) { // FIRST ROW IN STUDENTS ARRAY SECTION TABLE
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addStudentIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addStudentIdentifier];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.textLabel.text = @"Добавить/удалить студентов курса";
        
        cell.textLabel.textColor = [UIColor redColor];
        cell.backgroundColor = [UIColor lightGrayColor];
        
        return cell;
    }
    
    // NEXT ROWS FOR USERS ARRAY:
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:studentCellsIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentCellsIdentifier];
    }
    
    SiSStudent* student = [self.studentsAtCourse objectAtIndex:indexPath.row-1];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    
    if ((indexPath.section == SiSSectionsTypeStudentsArray) && (indexPath.row != 0)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SiSStudent* student = [self.studentsAtCourse objectAtIndex:indexPath.row-1];
        
        [self.course removeStudentObject:student];
        
        self.studentsAtCourse = [self.course.student allObjects];
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
    }
}

#pragma mark - === UITableViewDelegate ===

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == SiSSectionsTypeStudentsArray) { // HANDLE ONLY SECTIONS OF STUDENT
        
        if (indexPath.row == 0) { // ADDING NEW STUDENT HANDLE
            
            NSLog(@"Add Student Clicked");
            
            // *** MASTER REALIZATION - USING CHECKBOXES ***
            // MODAL VIEWCONTROLLER OR POPOVER WITH STUDENTS SELECTION TABLE
            
            NSSortDescriptor* firstNameDescriptor =
            [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
            
            NSSortDescriptor* lastNameDescriptor =
            [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
            
            NSArray* allStudents = [[SiSDataManager sharedManager] getAllObjectsForName:@"SiSStudent" andSortUsingDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
            
            SiSStudentSelectionViewController* vc = [[SiSStudentSelectionViewController alloc] init];
            
            vc.allStudents = allStudents;
            vc.selectedStudents = self.studentsAtCourse;
            
            vc.course = self.course;
            
            vc.delegate = self;
            
            
            // *** PUSH ON STACK:
            // [self.navigationController pushViewController:vc animated:YES];
            
            // *** MODAL CONTROLLER OR POPOVER:
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // IF WE ARE ON IPAD
                
                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                
                [self showControllrer:vc inPopoverFromSender:cell];
                
            } else { // IF WE ARE ON IPHONE
                
                [self showControllerAsModal:vc];
            }
            
            
        } else {
            SiSStudent* student = [self.studentsAtCourse objectAtIndex:indexPath.row - 1];
            
            SiSAddStudentViewController* vc = [[SiSAddStudentViewController alloc] init];
            
            vc.student = student;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
    }
    
}

#pragma mark - === UITextFieldDelegate ===

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return self.isEditMode ? YES : NO;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.teacherTextField]) {
        
        NSSortDescriptor* firstNameDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        
        NSSortDescriptor* lastNameDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        
        NSArray* allTeachers = [[SiSDataManager sharedManager] getAllObjectsForName:@"SiSTeacher"
                                                            andSortUsingDescriptors:@[firstNameDescriptor,lastNameDescriptor]];
        
        SiSTeacherSelectionViewController* vc = [[SiSTeacherSelectionViewController alloc] init];
        
        vc.allTeachers = allTeachers;
        
        vc.course = self.course;
        
//        vc.delegate = self;
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { // IF WE ARE ON IPAD
            
            [self showControllrer:vc inPopoverFromSender:textField];
            
        } else { // IF WE ARE ON IPHONE
            
            [self showControllerAsModal:vc];
            
        }
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.teacherTextField]) {
        [textField resignFirstResponder];
        
    } else {
        
        if ([textField isEqual:self.nameTextField]) {
            
            [self.subjectTextField becomeFirstResponder];
            
        } else if ([textField isEqual:self.subjectTextField]) {
            
            [self.departmentTextField becomeFirstResponder];
            
        } else {
            
            [self.teacherTextField becomeFirstResponder];
        }
    }
    
    return NO;
}

#pragma mark - +++ SiSStudentSelectionDelegate +++

- (void) studentsSelectionDidEnd:(NSArray*) studentsSelected {
    
    self.studentsAtCourse = [self.course.student allObjects];
    
    [[SiSDataManager sharedManager] saveContext];
    
    [self.tableView reloadData];
    
}

#pragma mark - +++ SiSTeacherSelectionDelegate +++

- (void) teacherSelectionDidEnd:(SiSTeacher*) teacherSelected {
    
    self.teacherAtCourse = self.course.teacher;
    
    [[SiSDataManager sharedManager] saveContext];
    
    [self.tableView reloadData];
    
}


@end
