//
//  User+CoreDataProperties.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/11/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var authentication: String?
    @NSManaged var password: String?
    @NSManaged var username: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var email: String?

}
