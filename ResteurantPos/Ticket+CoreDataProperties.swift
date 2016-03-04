//
//  Ticket+CoreDataProperties.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/3/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ticket {

    @NSManaged var grutuity: String?
    @NSManaged var subTotal: String?
    @NSManaged var tax: String?
    @NSManaged var ticketNumber: String?
    @NSManaged var totalPrice: String?
    @NSManaged var item: String?
    @NSManaged var price: String?

}
