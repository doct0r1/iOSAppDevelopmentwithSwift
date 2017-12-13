//
//  Liked+CoreDataProperties.swift
//  Photowall
//
//  Created by Ali TANIRLAR on 15.08.2017.
//  Copyright © 2017 Inohive. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Liked {

    @NSManaged var regularURL: String?
    @NSManaged var smallURL: String?
    @NSManaged var username: String?
    @NSManaged var id: String?

}
