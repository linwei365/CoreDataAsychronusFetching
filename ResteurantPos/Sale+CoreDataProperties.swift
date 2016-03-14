//
//  Sale+CoreDataProperties.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/14/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Sale {

    @NSManaged var orderNumber: String?
    @NSManaged var total: String?
    @NSManaged var orderTime: String?
    @NSManaged var tax: String?

}
