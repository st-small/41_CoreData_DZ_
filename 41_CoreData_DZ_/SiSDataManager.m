//
//  SiSDataManager.m
//  41_CoreData_DZ_
//
//  Created by Stas on 05.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import "SiSDataManager.h"
#import <UIKit/UIKit.h>


static NSString* firstName[] = {@"Иван", @"Петр", @"Сидор", @"Семен", @"Федор",
    @"Степан", @"Олег", @"Андрей", @"Борис", @"Николай",
    @"Игорь", @"Иван", @"Владимир", @"Кирилл", @"Максим",
    @"Михаил", @"Александр", @"Алексей", @"Павел", @"Роман",
    @"Руслан", @"Сергей", @"Станислав", @"Юрий", @"Поликарп"};

static NSString* lastName[] = {@"Иванов", @"Петров", @"Сидоров", @"Семенов", @"Федоров",
    @"Степанов", @"Олегов", @"Андреев", @"Борисов", @"Николаев",
    @"Игорев", @"Иванов", @"Владимиров", @"Кириллов", @"Максимов",
    @"Михайлов", @"Александров", @"Алексеев", @"Павлов", @"Романов",
    @"Русланов", @"Сергеев", @"Станиславов", @"Юрьев", @"Поликарпов"};

static NSString* kDepartmentTech            = @"Technical";
static NSString* kDepartmentHumanitarian    = @"Humanitarian";
static NSString* kDepartmentEconomics       = @"Economics";


static NSString* kSubjectTechProgramming    = @"Programming";
static NSString* kSubjectTechPhysics        = @"Physics";
static NSString* kSubjectTechTelecomm       = @"Telecom";

static NSString* kSubjectHumHistory         = @"History";
static NSString* kSubjectHumArt             = @"Art";
static NSString* kSubjectHumLinguistics     = @"Linguistics";

static NSString* kSubjectEcoAccounting      = @"Accounting";
static NSString* kSubjectEcoManagement      = @"Management";
static NSString* kSubjectEcoStockMarket     = @"StockMarket";

@interface SiSDataManager ()

@end

@implementation SiSDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (SiSDataManager*)sharedManager {
    
    static SiSDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SiSDataManager alloc] init];
    });
    
    return manager;
    
}

//^^^^^^^^^^^^^^^^^^^^^RANDOM E-MAIL^^^^^^^^^^^^^^^^^^^^^^^^
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- (NSString*) getRandomEmail {
    
    NSString *answer = [NSString stringWithFormat:@"%@@%@.com", [self getRandomString], [self getRandomString]];
    
    return answer;
}

- (NSString*) getRandomString {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz0123456789";
    int len = [self getRandomIntBetweenBottomInt:1 andTopInt:7];
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i < len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

- (int) getRandomIntBetweenBottomInt:(int)bottom andTopInt:(int)top {
    
    int randomNumber = (arc4random() % top) + bottom;
    
    return randomNumber;
}

#pragma mark - Operations with array Core Data

- (NSArray*) allObjectsForName:(NSString*)name {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:name
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}

- (NSArray*) getAllObjectsForName:(NSString*) name andSortUsingDescriptors:(NSArray*) descriptors {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:name
                inManagedObjectContext:self.managedObjectContext];
    
    request.entity = description;
    
    [request setSortDescriptors:descriptors];
    
    NSError* reqestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&reqestError];
    
    if (reqestError) {
        NSLog(@"requestError = %@", [reqestError localizedDescription]);
    }
    
    return resultArray;
}

- (void) deleteAllObjectsForName:(NSString*)name {
    
    NSArray* allObjects = [self allObjectsForName:name];
    
    for (id object in allObjects) {
        
        [self.managedObjectContext deleteObject:object];
    }
    
    [self.managedObjectContext save:nil];
}


- (void) clearDataBaseWithName:(NSString*)nameEntity {
    
    [self deleteAllObjectsForName:nameEntity];
}

#pragma mark - === SiSStudents ===

- (SiSStudent*) addEmptyStudent {
    SiSStudent* student = [NSEntityDescription insertNewObjectForEntityForName:@"SiSStudent" inManagedObjectContext:self.managedObjectContext];
    student.firstName = nil;
    student.lastName = nil;
    student.eMail = nil;
    student.courses = nil;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return student;
}

- (SiSStudent*) addRandomStudent {
    
    SiSStudent* student = [NSEntityDescription insertNewObjectForEntityForName:@"SiSStudent"
                                                        inManagedObjectContext:self.managedObjectContext];
    
    student.firstName = firstName[arc4random_uniform(25)];
    student.lastName = lastName[arc4random_uniform(25)];
    student.eMail = [self getRandomEmail];
    
    [self setCoursesForStudent:student fromCoursesArray:[self generateCourses]];
    
    return student;
}

- (SiSTeacher*) addRandomTeacher {
    
    //CREATE RANDOM TEACHER, BUT CHECK IT: IT SHOULDN'T DUPLICATE
    
    NSString* name = [NSString stringWithFormat:@"Пан %@", firstName[arc4random_uniform(25)]];
    NSString* surname = lastName[arc4random_uniform(25)];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"SiSTeacher"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName = %@ && lastName = %@", name, surname];
    fetch.predicate = predicate;
    
    NSArray* result = [self.managedObjectContext executeFetchRequest:fetch
                                                                   error:nil];
    if ([result count] > 0) {
        
        SiSTeacher* teacher = [result firstObject];
        
        return teacher;
        
    } else {
        
        SiSTeacher* teacher = [NSEntityDescription insertNewObjectForEntityForName:@"SiSTeacher"
                                                            inManagedObjectContext:self.managedObjectContext];
        teacher.firstName = name;
        teacher.lastName = surname;
        
        return teacher;
    }
    
}

- (SiSCourse*) addRandomCourseAndTeacher {
    
    SiSCourse* course = [[self generateCourses] objectAtIndex:arc4random_uniform(5) + 1];
    SiSTeacher* teacher = [self addRandomTeacher];
    
    course.teacher = teacher;
    
    return course;
}

- (SiSCourse*) addCourseWithName:(NSString*) name withSubject:(NSString*)subject andIndustry:(NSString*) industry {
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"SiSCourse"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    request.predicate = predicate;
    
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    if ([result count] > 0) {
        SiSCourse* course = [result firstObject];
        
        return course;
        
    } else {
        
        SiSCourse* course =
        [NSEntityDescription insertNewObjectForEntityForName:@"SiSCourse"
                                      inManagedObjectContext:self.managedObjectContext];
        
        course.name = name;
        course.subject = subject;
        course.industry = industry;
        
        //Проверка на наличие у курса учителя
        
        if (course.teacher == nil) {
            
            course.teacher = [self addRandomTeacher];
            
        }
        
        return course;
    }
    
}

- (NSArray*) generateCourses {
    
    // *** TECHNICAL COURSES
    SiSCourse* techProgCourse1 = [self addCourseWithName:@"iOS" withSubject:kSubjectTechProgramming andIndustry:kDepartmentTech];
    SiSCourse* techProgCourse2 = [self addCourseWithName:@"Java" withSubject:kSubjectTechProgramming andIndustry:kDepartmentTech];
    SiSCourse* techProgCourse3 = [self addCourseWithName:@"PHP" withSubject:kSubjectTechProgramming andIndustry:kDepartmentTech];
    SiSCourse* techProgCourse4 = [self addCourseWithName:@"C++" withSubject:kSubjectTechProgramming andIndustry:kDepartmentTech];
    
    SiSCourse* techTelecomCourse1 = [self addCourseWithName:@"Cisco" withSubject:kSubjectTechTelecomm andIndustry:kDepartmentTech];
    SiSCourse* techTelecomCourse2 = [self addCourseWithName:@"Juniper" withSubject:kSubjectTechTelecomm andIndustry:kDepartmentTech];
    SiSCourse* techTelecomCourse3 = [self addCourseWithName:@"Extreme Networks" withSubject:kSubjectTechTelecomm andIndustry:kDepartmentTech];
    SiSCourse* techTelecomCourse4 = [self addCourseWithName:@"Avaya" withSubject:kSubjectTechTelecomm andIndustry:kDepartmentTech];
    
    SiSCourse* techPhysicsCourse1 = [self addCourseWithName:@"Nuclear Physics" withSubject:kSubjectTechPhysics andIndustry:kDepartmentTech];
    SiSCourse* techPhysicsCourse2 = [self addCourseWithName:@"Theoretical Physics" withSubject:kSubjectTechPhysics andIndustry:kDepartmentTech];
    SiSCourse* techPhysicsCourse3 = [self addCourseWithName:@"Astrophysics" withSubject:kSubjectTechPhysics andIndustry:kDepartmentTech];
    SiSCourse* techPhysicsCourse4 = [self addCourseWithName:@"Solid states" withSubject:kSubjectTechPhysics andIndustry:kDepartmentTech];
    
    NSArray* techCourses = @[techProgCourse1, techProgCourse2, techProgCourse3, techProgCourse4,
                             techTelecomCourse1, techTelecomCourse2, techTelecomCourse3, techTelecomCourse4,
                             techPhysicsCourse1, techPhysicsCourse2, techPhysicsCourse3, techPhysicsCourse4];
    
    // *** HUMANITARIAN COURSES
    SiSCourse* humArtCourse1 = [self addCourseWithName:@"Impressionist paintings" withSubject:kSubjectHumArt andIndustry:kDepartmentHumanitarian];
    SiSCourse* humArtCourse2 = [self addCourseWithName:@"Antique Sculpture" withSubject:kSubjectHumArt andIndustry:kDepartmentHumanitarian];
    SiSCourse* humArtCourse3 = [self addCourseWithName:@"Modern Art" withSubject:kSubjectHumArt andIndustry:kDepartmentHumanitarian];
    SiSCourse* humArtCourse4 = [self addCourseWithName:@"Baroque Music" withSubject:kSubjectHumArt andIndustry:kDepartmentHumanitarian];
    
    SiSCourse* humLingCourse1 = [self addCourseWithName:@"English" withSubject:kSubjectHumLinguistics andIndustry:kDepartmentHumanitarian];
    SiSCourse* humLingCourse2 = [self addCourseWithName:@"Japaneese" withSubject:kSubjectHumLinguistics andIndustry:kDepartmentHumanitarian];
    SiSCourse* humLingCourse3 = [self addCourseWithName:@"Russian" withSubject:kSubjectHumLinguistics andIndustry:kDepartmentHumanitarian];
    SiSCourse* humLingCourse4 = [self addCourseWithName:@"Mandarin" withSubject:kSubjectHumLinguistics andIndustry:kDepartmentHumanitarian];
    
    SiSCourse* humHistoryCourse1 = [self addCourseWithName:@"Ancient Rome history" withSubject:kSubjectHumHistory andIndustry:kDepartmentHumanitarian];
    SiSCourse* humHistoryCourse2 = [self addCourseWithName:@"Slavery in USA" withSubject:kSubjectHumHistory andIndustry:kDepartmentHumanitarian];
    SiSCourse* humHistoryCourse3 = [self addCourseWithName:@"Greek mythology" withSubject:kSubjectHumHistory andIndustry:kDepartmentHumanitarian];
    SiSCourse* humHistoryCourse4 = [self addCourseWithName:@"Middle Ages histiry" withSubject:kSubjectHumHistory andIndustry:kDepartmentHumanitarian];
    
    NSArray* humCourses = @[humArtCourse1, humArtCourse2, humArtCourse3, humArtCourse4,
                            humLingCourse1, humLingCourse2, humLingCourse3, humLingCourse4,
                            humHistoryCourse1, humHistoryCourse2, humHistoryCourse3, humHistoryCourse4];
    
    // *** ECONOMICS COURSES
    SiSCourse* econManagementCourse1 = [self addCourseWithName:@"Financial management" withSubject:kSubjectEcoManagement andIndustry:kDepartmentEconomics];
    SiSCourse* econManagementCourse2 = [self addCourseWithName:@"Project management" withSubject:kSubjectEcoManagement andIndustry:kDepartmentEconomics];
    SiSCourse* econManagementCourse3 = [self addCourseWithName:@"Effective management" withSubject:kSubjectEcoManagement andIndustry:kDepartmentEconomics];
    
    SiSCourse* econStocksCourse1 = [self addCourseWithName:@"Forex" withSubject:kSubjectEcoStockMarket andIndustry:kDepartmentEconomics];
    SiSCourse* econStocksCourse2 = [self addCourseWithName:@"NASDAQ" withSubject:kSubjectEcoStockMarket andIndustry:kDepartmentEconomics];
    SiSCourse* econStocksCourse3 = [self addCourseWithName:@"General Stocks" withSubject:kSubjectEcoStockMarket andIndustry:kDepartmentEconomics];
    
    SiSCourse* econAccountCourse1 = [self addCourseWithName:@"General accounting" withSubject:kSubjectEcoAccounting andIndustry:kDepartmentEconomics];
    SiSCourse* econAccountCourse2 = [self addCourseWithName:@"Finance accounting" withSubject:kSubjectEcoAccounting andIndustry:kDepartmentEconomics];
    SiSCourse* econAccountCourse3 = [self addCourseWithName:@"Black accountist" withSubject:kSubjectEcoAccounting andIndustry:kDepartmentEconomics];
    
    NSArray* econCourses = @[econManagementCourse1, econManagementCourse2, econManagementCourse3,
                             econStocksCourse1, econStocksCourse2, econStocksCourse3,
                             econAccountCourse1, econAccountCourse2, econAccountCourse3];
    
    NSMutableArray* tmpArray = [NSMutableArray arrayWithArray:techCourses];
    [tmpArray addObjectsFromArray:humCourses];
    [tmpArray addObjectsFromArray:econCourses];
    
    NSArray* courses = tmpArray;
    
    return courses;
    
}

- (void) setCoursesForStudent:(SiSStudent*)student fromCoursesArray:(NSArray*)courses {
    
    // ADD 1-5 RANDOM COURSES TO STUDENT
    NSInteger number = arc4random_uniform(5) + 1;
    while ([student.courses count] < number) {
        
        NSUInteger count = [courses count];
        
        SiSCourse* course = [courses objectAtIndex:arc4random_uniform(count)];
        course.teacher = [self addRandomTeacher];
        
        if (![student.courses containsObject:course]) {
            [student addCoursesObject:course];
        }
    }
    
}

- (void) generateAndAddStudentBatch {
    
    NSArray* courses = [self generateCourses]; // FOR FIRST TIME GENERATING - WHEN DATABASE IS EMPTY
    
    NSError* error = nil;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"SiSStudent"];
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    if ([result count] > 0) {
        for (SiSStudent* student in result) {
            
            [self setCoursesForStudent:student fromCoursesArray:courses];
        }
        
    } else {
        
        for (int i = 0; i < 3; i++) {
            SiSStudent* student = [self addRandomStudent];
            [self setCoursesForStudent:student fromCoursesArray:courses];
        }

    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}


#pragma mark - Core Data stack
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Stnislav-Shiyanovskiy._1_CoreData_DZ_" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"_1_CoreData_DZ_" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"_1_CoreData_DZ_.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
