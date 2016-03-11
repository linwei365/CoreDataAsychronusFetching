//
//  TicketInfo+CoreDataProperties.swift
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

extension TicketInfo {

    @NSManaged var tax: String?
    @NSManaged var companyName: String?
    @NSManaged var companyStreetAddress: String?
    @NSManaged var gratuity: String?
    @NSManaged var companyCity: String?
    @NSManaged var companyState: String?
    @NSManaged var compnayZip: String?
    @NSManaged var compnayPhoneNumber: String?

}
