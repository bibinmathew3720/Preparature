//
//  User.swift
//  Preparture
//
//  Created by Bibin Mathew on 7/30/18.
//  Copyright © 2018 praveen raj. All rights reserved.
//

import UIKit
import CoreData

class User: NSManagedObject {
    static func saveUserData(userData:LogInResponseModel){
        if let user = User.getUser() {
            updateUserDB(user: user, userData: userData)
        } else {
            let user = CoreDataHandler.sharedInstance.newEntityForName(entityName: "User") as? User
            user?.userId = userData.userId
            updateUserDB(user:user!, userData: userData)
        }
    }
    
    class func updateUserDB(user:User,userData:LogInResponseModel) {
        user.name = userData.name
        user.userName = userData.userName
        user.email = userData.userEmail
        user.imageUrl = userData.userProfileImageUrl
        CoreDataHandler.sharedInstance.saveContext()
    }
    
    class func getUser() -> User? {
        let detailsArrayPost:NSArray = CoreDataHandler.sharedInstance.getAllDatas(entity: "User") as NSArray
        if (detailsArrayPost.count != 0) {
            return detailsArrayPost.object(at: 0) as? User
        }
        return nil
    }
    
    class func deleteUser() {
        CoreDataHandler.sharedInstance.deleteAllData(name: "User")
        CoreDataHandler.sharedInstance.saveContext()
    }
}
