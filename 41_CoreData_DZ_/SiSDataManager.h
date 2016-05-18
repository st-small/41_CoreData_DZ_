//
//  SiSDataManager.h
//  41_CoreData_DZ_
//
//  Created by Stas on 05.05.16.
//  Copyright © 2016 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SiSStudent.h"
#import "SiSTeacher.h"

@interface SiSDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel* managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;

- (void) saveContext;
- (NSURL*)applicationDocumentsDirectory;

+ (SiSDataManager*)sharedManager;

- (SiSStudent*) addRandomStudent;
- (SiSStudent*) addEmptyStudent;
- (SiSTeacher*) addRandomTeacher;
- (void) clearDataBaseWithName:(NSString*)nameEntity;
- (void) generateAndAddStudentBatch;
- (NSArray*) getAllObjectsForName:(NSString*) name andSortUsingDescriptors:(NSArray*) descriptors;

@end
