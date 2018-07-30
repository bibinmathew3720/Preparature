
//
//  CoreDataHandler.swift
//  EQ Chat
//
//  Created by Vaisakh krishnan on 10/29/15.
//  Copyright © 2015 eqchat. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataHandler: NSObject {
    public static let sharedInstance = CoreDataHandler()
    
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(Bundle.main.infoDictionary!["CFBundleName"] as! String + ".sqlite")
        //print("CLCordata Handler URL  === \(String(describing: url))" )
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let optionDictionary: [NSObject : AnyObject] = [NSMigratePersistentStoresAutomaticallyOption as NSObject: true as AnyObject, NSInferMappingModelAutomaticallyOption as NSObject: true as AnyObject]
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: optionDictionary)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        //let modelURL = Bundle.main.url(forResource: Bundle.main.infoDictionary!["CFBundleName"] as? String, withExtension: "momd")!
          let modelURL = Bundle.main.url(forResource:  "PreparatureModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    // MARK: - Entity description for given name.
   public func entityForName(entityName:String)-> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext!)!
    }
    
    // MARK: - Create a new entity for given name.
   public func newEntityForName(entityName:String)-> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self.managedObjectContext!)
    }
    
    // MARK: - Core Data Saving support
    
    //    func saveContext ()-> Void {
    //        if let moc = self.managedObjectContext {
    //            var error: NSError? = nil
    //            if moc.hasChanges &&  !moc.save() {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                NSLog("Unresolved error \(error), \(error!.userInfo)")
    //                abort()
    //            }
    //            else {
    //                print("Data Saved SuccesFully ")
    //            }
    //
    //        }
    //    }
    
   public func saveContext () {
        if managedObjectContext!.hasChanges {
            do {
                try managedObjectContext!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    //MARK:- Core Data Fetch Details
    
    public func getAllDatas(entity:String)-> [AnyObject] {
        let fetchRequest : NSFetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
        do {
            return   try self.managedObjectContext!.fetch(fetchRequest)
        }
        catch {
            print(error)
        }
        return [AnyObject]()
    }
    
   public func getAllDatasGroupBy(entity:String,property:AnyObject)-> NSArray {
        let fetchRequest : NSFetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
        fetchRequest.propertiesToGroupBy = [property]
        fetchRequest.propertiesToFetch = [property]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        return try! self.managedObjectContext!.fetch(fetchRequest) as NSArray
    }
    
    //MARK:- Fetch average value from db
   public func getAverageOfDatas(entity:String,property:String,predicate:NSPredicate?)-> Double? {
        var average:Double? = 0.0
        let fetchRequest : NSFetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
        if(predicate != nil) {
            fetchRequest.predicate = predicate
        }
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let  aveExDescr: NSExpressionDescription = NSExpressionDescription()
        aveExDescr.name = "AverageValue"
        aveExDescr.expression = NSExpression(forFunction:"average:", arguments:[NSExpression(forKeyPath: property)])
        aveExDescr.expressionResultType =  NSAttributeType.floatAttributeType
        fetchRequest.propertiesToFetch = [aveExDescr]
        
        let dataArray: [AnyObject]? = try! self.managedObjectContext!.fetch(fetchRequest) as [AnyObject]
        
        if(dataArray!.count != 0 ) {
            let tempDict:[String:AnyObject] = dataArray![0] as! [String : AnyObject]
            let averageValue:AnyObject? = tempDict["AverageValue"]
            if let avg = averageValue {
                let tempString =  avg as! NSNumber
                average =  Double(tempString)
            }
        }
        
        return average
    }
    
    //MARK:- Fetch Max value from db
   public func getMaxOfDatas(entity:String,property:String,predicate:NSPredicate?)-> Double? {
        var maximum:Double? = 0
        let fetchRequest : NSFetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
        if(predicate != nil) {
            fetchRequest.predicate = predicate
        }
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let  aveExDescr: NSExpressionDescription = NSExpressionDescription()
        aveExDescr.name = "MaximumValue"
        aveExDescr.expression = NSExpression(forFunction:"max:", arguments:[NSExpression(forKeyPath: property)])
        aveExDescr.expressionResultType =  NSAttributeType.floatAttributeType
        fetchRequest.propertiesToFetch = [aveExDescr]
        
        let dataArray: [AnyObject]? = try! self.managedObjectContext!.fetch(fetchRequest) as [AnyObject]
        if(dataArray!.count != 0 ) {
            let tempDict:[String:AnyObject] = dataArray![0] as! [String : AnyObject]
            let maximumValue:AnyObject? = tempDict["MaximumValue"]
            if let max = maximumValue {
                let tempString =   max as! NSNumber
                maximum =  Double(tempString)
            }
            
        }
        return maximum
        
    }
    
    public func getAllDatasWithPredicate(entity:String,predicate:NSPredicate?, sortDescriptor: NSSortDescriptor?)-> [AnyObject] {
        let fetchRequest : NSFetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: entity)
        
        if(predicate != nil) {
            fetchRequest.predicate = predicate
        }
        if(sortDescriptor != nil) {
            fetchRequest.sortDescriptors = [sortDescriptor!]
        }
        return try! self.managedObjectContext!.fetch(fetchRequest) as [AnyObject]
    }
    
    
    
    // MARK: -To Delete a managed object.
   public func deleteObject(object:NSManagedObject) ->Void {
        self.managedObjectContext?.delete(object)
    }
    
    public func deleteAllDataWithCondition(name: String,predicate:NSPredicate?) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            //fetchRequest.predicate = predicate
            if #available(iOS 9.0, *) {
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                _ = try (persistentStoreCoordinator?.execute(deleteRequest, with: self.managedObjectContext!))!
            } else {
                // Fallback on earlier versions
            }
            
        } catch let error as NSError {
            print(error)
        }
    }
    
   public func deleteAllData(name: String) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            if #available(iOS 9.0, *) {
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                _ = try (persistentStoreCoordinator?.execute(deleteRequest, with: self.managedObjectContext!))!
            } else {
                // Fallback on earlier versions
            }
            
        } catch let error as NSError {
            print(error)
        }
    }
    
   public func updateValue(entityName:String,objectKey:String,newObject:AnyObject){
        let context = managedObjectContext
        let entity = entityForName(entityName: entityName)
        do{
            let batchUpdateRequest = NSBatchUpdateRequest(entity: entity )
            batchUpdateRequest.resultType = NSBatchUpdateRequestResultType.updatedObjectIDsResultType
            batchUpdateRequest.propertiesToUpdate = [objectKey: newObject]
            try context!.execute(batchUpdateRequest)
        }catch let error as NSError {
            print(error)
        }
    }
    
}
