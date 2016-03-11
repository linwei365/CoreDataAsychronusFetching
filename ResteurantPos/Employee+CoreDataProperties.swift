//
//  Employee+CoreDataProperties.swift
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

extension Employee {

    @NSManaged var employeeFirstname: String?
    @NSManaged var employeePinNumber: String?
    @NSManaged var empolyeeLastname: String?
    @NSManaged var orderTime: String?
    @NSManaged var clockInTime: String?
    @NSManaged var orderNumber: String?
    @NSManaged var table: NSSet?
    @NSManaged var takeoutCheck: NSSet?

}
