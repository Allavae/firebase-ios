//
//  MORestauraunt.swift
//  FriendlyEats
//
//  Created by Alex Logan on 29/11/2017.
//  Copyright © 2017 Firebase. All rights reserved.
//

import Foundation
import CoreData


extension NSRestauraunt {
    var restaurant : Restaurant {
        get {
            return Restaurant(dictionary: [
                "name": self.name,
                "category": self.category,
                "city": self.city,
                "price": self.price,
                "avgRating": self.avgRating,
                "numRatings": self.numRatings,
                "url" : self.url
                ])!
        }
        set {
            self.name = newValue.name
            self.category = newValue.category
            self.price = Int16(newValue.price)
            self.city = newValue.city
            self.avgRating = Double(newValue.averageRating)
            self.numRatings = Int64(newValue.ratingCount)
            self.url = newValue.url
        }
    }
}
