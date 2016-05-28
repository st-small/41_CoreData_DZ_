//
//  SiSTeacherDetailsViewController.m
//  41_CoreData_DZ_
//
//  Created by Stanly Shiyanovskiy on 26.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSTeacherDetailsViewController.h"
#import "SiSDataManager.h"

@interface SiSTeacherDetailsViewController ()

@property (strong, nonatomic) UITextField* textFieldFirstName;
@property (strong, nonatomic) UITextField* textFieldLastName;

@property (strong, nonatomic) NSArray* courses;

@property (assign, nonatomic) BOOL isEditMode;

@end

typedef enum {
    
    SiSTextFieldTypeFirstName,
    SiSTextFieldTypeLastName,
    SiSTextFieldTypeCourse,
    
} SiSTextFieldType;

typedef enum {
    
    SiSSectionsTypeTeacherInfo,
    SiSSectionsTypeCoursesArray,
    
} SiSSectionsType;


@implementation SiSTeacherDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Профиль преподавателя:";
    
    NSMutableArray* tmpSectionsArray = [NSMutableArray array];
    
    self.labels = @[@"Имя:", @"Фамилия:"];
    
    self.placeholders = @[@"Имя преподавателя", @"Фамилия преподавателя", @"Email преподавателя", @"Курсы преподавателя"];
    
    self.sectionsInfos = @[@"Информация о преподавателе:", @"Преподаватель(-ли) курса(-ов):", @"Изучает курсы:"];
    
    [tmpSectionsArray addObject:self.labels];
    
    if ([self.teacher.course count] > 0) {
        [tmpSectionsArray addObject:self.teacher.course];
        self.courses = [self.teacher.course allObjects];
    }
    
    self.sectionsArray = tmpSectionsArray;
}

#pragma mark - === Actions ===

- (void) actionInfoChanged:(UITextField*) sender {
    
    switch (sender.tag) {
        case SiSTextFieldTypeFirstName:
            self.teacher.firstName = sender.text;
            break;
            
        case SiSTextFieldTypeLastName:
            self.teacher.lastName = sender.text;
            break;
            
        default:
            break;
    }
    
}

- (void) actionSave:(UIBarButtonItem*) sender {
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(actionSave:)];
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
    [[SiSDataManager sharedManager] saveContext];
    
    [self showAlertWhenSave];
}

- (void) showAlertWhenSave {
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Сохранить изменения?!"
                                message:@"Ваши изменения сохранятся. Нажмите ""ДА"" для сохранения и возврата или ""НЕТ"" для продолжения редактирования" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"ДА"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [[SiSDataManager sharedManager] saveContext];
                                                         
                                                         [self returnBack];
                                                     }];
    
    UIAlertAction* NopeAction = [UIAlertAction actionWithTitle:@"НЕТ"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
    
    [alert addAction:okAction];
    [alert addAction:NopeAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) returnBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
        self.isEditMode = YES;
        [self.textFieldFirstName becomeFirstResponder];
    } else {
        [self.textFieldFirstName resignFirstResponder];
        [self.textFieldLastName resignFirstResponder];
        self.isEditMode = NO;
    }
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(actionSave:)];
    [self.navigationItem setRightBarButtonItem:saveButton animated:YES];
    
}

#pragma mark - === UITableViewDataSource ===

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionsArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.sectionsInfos objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == SiSSectionsTypeTeacherInfo) {
        return [self.labels count];
    }
    
    else {
        
        return [self.courses count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* infoCellsIdentifier = @"infoCell";
    static NSString* teacherInCourseIdentifier = @"teacherInCourseCell";
    //static NSString* studyingCourseIdentifier = @"studyingCourseCell";
    
    if (indexPath.section == SiSSectionsTypeTeacherInfo) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:infoCellsIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:infoCellsIdentifier];
        }
        
        cell.textLabel.text = [self.labels objectAtIndex:indexPath.row];
        
        // TEXT FIELDS FOR EDITING STUDENT INFO
        
        CGRect cellRect = cell.bounds;
        CGRect tfRect = CGRectMake(cellRect.origin.x+ 150, cellRect.origin.y + 5, cellRect.size.width - 165, cellRect.size.height - 10);
        
        UITextField* tf = [[UITextField alloc] initWithFrame:tfRect];
        [tf setBorderStyle:UITextBorderStyleRoundedRect];
        
        [tf setSpellCheckingType:UITextSpellCheckingTypeNo];
        [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        NSString* tfText = nil;
        switch (indexPath.row) {
            case SiSTextFieldTypeFirstName:
                tfText = self.teacher.firstName;
                tf.clearButtonMode = UITextFieldViewModeWhileEditing;
                [tf setReturnKeyType:UIReturnKeyNext];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                [tf setKeyboardType:UIKeyboardTypeDefault];
                tf.tag = SiSTextFieldTypeFirstName;
                
                self.textFieldFirstName = tf;
                self.textFieldFirstName.delegate = self;
                break;
                
            case SiSTextFieldTypeLastName:
                tfText = self.teacher.lastName;
                tf.clearButtonMode = UITextFieldViewModeWhileEditing;
                [tf setReturnKeyType:UIReturnKeyDone];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                [tf setKeyboardType:UIKeyboardTypeDefault];
                tf.tag = SiSTextFieldTypeLastName;
                
                self.textFieldLastName = tf;
                self.textFieldLastName.delegate = self;
                break;
                
            default:
                break;
        }
        
        tf.text = tfText;
        tf.placeholder = [self.placeholders objectAtIndex:indexPath.row];
        
        [tf addTarget:self action:@selector(actionInfoChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [cell addSubview:tf];
        
        return cell;
        
    } else {
    
    // 2nd SECTION - TEACHER IN COURSES SECTION OR STUDYING COURSES SECTION
        
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:teacherInCourseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:teacherInCourseIdentifier];
    }
    
    SiSCourse* course = [self.courses objectAtIndex:indexPath.row];
    
    cell.textLabel.text = course.name;
    
    return cell;
        
    }
}
    
#pragma mark - === UITextFieldDelegate ===

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != SiSSectionsTypeTeacherInfo) {
        
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == SiSSectionsTypeCoursesArray) {
            
            SiSCourse* course = [self.courses objectAtIndex:indexPath.row];
            [self.teacher removeCourseObject:course];
            self.courses = [self.teacher.course allObjects];
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationLeft];
            
            if ([self.courses count] < 1) {
                
                [self returnBack];
                
            }
            
            [tableView endUpdates];
        }
        
    }
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return self.isEditMode ? YES : NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"textFieldDidBeginEditing");
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.textFieldFirstName]) {
        self.teacher.firstName = self.textFieldFirstName.text;
        
    } else {
        self.teacher.lastName = self.textFieldLastName.text;
    }
    
}

-(void)dealloc{
    
    [[SiSDataManager sharedManager] saveContext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.textFieldLastName]) {
        
        [textField resignFirstResponder];
        
    } else {
        
        [self.textFieldLastName becomeFirstResponder];
            
    }
    
    return NO;
}




@end
