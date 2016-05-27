//
//  SiSAddStudentViewController.m
//  41_CoreData_DZ_
//
//  Created by stas on 06.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSAddStudentViewController.h"
#import "SiSDataManager.h"

@interface SiSAddStudentViewController ()

@property (strong, nonatomic) UITextField* textFieldFirstName;
@property (strong, nonatomic) UITextField* textFieldLastName;
@property (strong, nonatomic) UITextField* textFieldEmail;

@property (strong, nonatomic) NSArray* coursesStudying;
@property (strong, nonatomic) NSMutableArray* teachers;

@property (assign, nonatomic) BOOL isEditMode;

@end

typedef enum {
    
    SiSTextFieldTypeFirstName,
    SiSTextFieldTypeLastName,
    SiSTextFieldTypeEmail,
    SiSTextFieldTypeCourse,
    
} SiSTextFieldType;

typedef enum {
    
    SiSSectionsTypeStudentInfo,
    SiSSectionsTypeTeachingCoursesArray,
    SiSSectionsTypeStudyingCoursesArray
    
} SiSSectionsType;

@implementation SiSAddStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Редактировать профиль:";
    
    NSMutableArray* tmpSectionsArray = [NSMutableArray array];
    
    self.labels = @[@"Имя:", @"Фамилия:", @"Эл. почта:"];
    
    self.placeholders = @[@"Имя студента", @"Фамилия студента", @"Email студента", @"Курсы студента"];
    
    self.sectionsInfos = @[@"Информация о студенте:", @"Преподаватель(-ли) курса(-ов):", @"Изучает курсы:"];
    
    [tmpSectionsArray addObject:self.labels];
    
    if ([self.student.courses count] > 0) {
        self.coursesStudying = [self.student.courses allObjects];
        [tmpSectionsArray addObject:self.coursesStudying];
        
        self.teachers = [NSMutableArray array];
        
        for (SiSCourse* course in self.student.courses) {
            
            SiSTeacher* teacher = course.teacher;
            
            [self.teachers addObject:teacher];
        }
     
        [tmpSectionsArray addObject:self.teachers];
    }
    
    self.sectionsArray = tmpSectionsArray;
}

#pragma mark - === Actions ===

- (void) actionInfoChanged:(UITextField*) sender {
    
    switch (sender.tag) {
        case SiSTextFieldTypeFirstName:
            self.student.firstName = sender.text;
            break;
            
        case SiSTextFieldTypeLastName:
            self.student.lastName = sender.text;
            break;
            
        case SiSTextFieldTypeEmail:
            self.student.eMail = sender.text;
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
        [self.textFieldEmail resignFirstResponder];
        
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
    
    if (section == SiSSectionsTypeStudentInfo) {
        
        return [self.labels count];
        
    } else if (section == SiSSectionsTypeTeachingCoursesArray) {
        
        return [self.teachers count];
    }
    
    else {
        
        return [self.coursesStudying count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* infoCellsIdentifier = @"infoCell";
    static NSString* teacherInCourseIdentifier = @"teacherInCourseCell";
    static NSString* studyingCourseIdentifier = @"studyingCourseCell";
    
    if (indexPath.section == SiSSectionsTypeStudentInfo) {
        
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
                tfText = self.student.firstName;
                tf.clearButtonMode = UITextFieldViewModeWhileEditing;
                [tf setReturnKeyType:UIReturnKeyNext];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                [tf setKeyboardType:UIKeyboardTypeDefault];
                tf.tag = SiSTextFieldTypeFirstName;
                
                self.textFieldFirstName = tf;
                self.textFieldFirstName.delegate = self;
                break;
                
            case SiSTextFieldTypeLastName:
                tfText = self.student.lastName;
                tf.clearButtonMode = UITextFieldViewModeWhileEditing;
                [tf setReturnKeyType:UIReturnKeyNext];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                [tf setKeyboardType:UIKeyboardTypeDefault];
                tf.tag = SiSTextFieldTypeLastName;
                
                self.textFieldLastName = tf;
                self.textFieldLastName.delegate = self;
                break;
                
            case SiSTextFieldTypeEmail:
                tfText = self.student.eMail;
                tf.clearButtonMode = UITextFieldViewModeWhileEditing;
                [tf setReturnKeyType:UIReturnKeyDone];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [tf setKeyboardType:UIKeyboardTypeEmailAddress];
                tf.tag = SiSTextFieldTypeEmail;
                
                self.textFieldEmail = tf;
                self.textFieldEmail.delegate = self;
                break;
                
            default:
                break;
        }
        
        tf.text = tfText;
        tf.placeholder = [self.placeholders objectAtIndex:indexPath.row];
        
        [tf addTarget:self action:@selector(actionInfoChanged:) forControlEvents:UIControlEventEditingChanged];
        
        [cell addSubview:tf];
        
        return cell;
    }
    
    // 2nd SECTION - TEACHER IN COURSES SECTION OR STUDYING COURSES SECTION
    
    if (indexPath.section == SiSSectionsTypeTeachingCoursesArray) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:teacherInCourseIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:teacherInCourseIdentifier];
        }
        
        SiSTeacher* teacher = [self.teachers objectAtIndex:indexPath.row];;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
        
        return cell;
        
    } else {
        // STUDYING COURSES ARRAY:
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:studyingCourseIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studyingCourseIdentifier];
        }
        
        SiSCourse* course = [self.coursesStudying objectAtIndex:indexPath.row];
        
        cell.textLabel.text = course.name;
        
        return cell;
    }
    
}

#pragma mark - === UITextFieldDelegate ===

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SiSSectionsTypeStudyingCoursesArray) {
        
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == SiSSectionsTypeStudyingCoursesArray) {
            
            SiSCourse* course = [self.coursesStudying objectAtIndex:indexPath.row];
            [self.student removeCoursesObject:course];
            [self.teachers removeObject:course.teacher];
            self.coursesStudying = [self.student.courses allObjects];
            NSIndexPath* teachers = [NSIndexPath indexPathForRow:indexPath.row inSection:SiSSectionsTypeTeachingCoursesArray];
            NSIndexPath* courses = [NSIndexPath indexPathForRow:indexPath.row inSection:SiSSectionsTypeStudyingCoursesArray];
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[teachers, courses]
                             withRowAnimation:UITableViewRowAnimationLeft];
            
            if ([self.coursesStudying count] < 1) {
                
                NSMutableArray* temp = [NSMutableArray array];
                
                [temp addObject:self.labels];
                
                self.sectionsArray = temp;
                
                NSMutableIndexSet* teachersAndCoursesSectionsSet = [NSMutableIndexSet indexSet];
                
                [teachersAndCoursesSectionsSet addIndex:SiSSectionsTypeTeachingCoursesArray];
                [teachersAndCoursesSectionsSet addIndex:SiSSectionsTypeStudyingCoursesArray];
                
                [tableView deleteSections:teachersAndCoursesSectionsSet
                         withRowAnimation:UITableViewRowAnimationFade];
            }
            
            [tableView endUpdates];
        }
            
    }
        
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return self.isEditMode ? YES : NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSLog(@"textFieldDidBeginEditing");
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.textFieldFirstName]) {
        self.student.firstName = self.textFieldFirstName.text;
        if (self.student.firstName != nil) {
            self.textFieldEmail.text = [NSString stringWithFormat:@"%@777@gmail.com",self.textFieldLastName.text];
            self.student.eMail = self.textFieldEmail.text;
        }
        
    } else if ([textField isEqual:self.textFieldLastName]){
        self.student.lastName = self.textFieldLastName.text;
        if (self.student.lastName != nil) {
            self.textFieldEmail.text = [NSString stringWithFormat:@"%@777@gmail.com",self.textFieldLastName.text];
            self.student.eMail = self.textFieldEmail.text;
        }
    }else if ([textField isEqual:self.textFieldEmail]){
        self.student.eMail = self.textFieldEmail.text;
    }
    
}

-(void)dealloc{
    
    [[SiSDataManager sharedManager] saveContext];
}

- (void) returnBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.textFieldEmail]) {
        [textField resignFirstResponder];
        
    } else {
        
        if ([textField isEqual:self.textFieldFirstName]) {
            
            [self.textFieldLastName becomeFirstResponder];
            
        } else {
            
            [self.textFieldEmail becomeFirstResponder];
        }
    }
    
    return NO;
}

@end
