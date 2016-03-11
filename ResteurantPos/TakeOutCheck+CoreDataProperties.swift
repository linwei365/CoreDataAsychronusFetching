//
//  TakeOutCheck+CoreDataProperties.swift
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

extension TakeOutCheck {

    @NSManaged var takeoutOrderNumber: String?
    @NSManaged var time: String?
    @NSManaged var employee: Employee?
    @NSManaged var ticket: NSSet?

}
