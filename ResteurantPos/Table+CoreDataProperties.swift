//
//  Table+CoreDataProperties.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/10/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Table {

    @NSManaged var tableNumber: String?
    @NSManaged var employee: Employee?
    @NSManaged var ticket: NSSet?

}
