//
//  Business.swift
//  fresh_yelp
//
//  Created by Wanda Cheung on 10/4/14.
//

import Foundation
import CoreLocation

class Business: NSObject {
  
  var dictionary: NSDictionary
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
  }
  
  var name: String {
    get {
      return self.dictionary["name"] as String
    }
  }
  
  var imageURL: NSURL? {
    get {
      if let image = self.dictionary["image_url"] as? String {
        return NSURL(string: image.stringByReplacingOccurrencesOfString("ms.jpg", withString: "ls.jpg", options: nil, range: nil))
      }
      return nil
    }
  }
  
  var ratingImageURL: NSURL {
    get {
      return NSURL(string: self.dictionary["rating_img_url_large"] as String)
    }
  }
  
  var reviewCount: Int {
    get {
      return self.dictionary["review_count"] as Int
    }
  }
  
  var deals: [AnyObject]? {
    get {
      if let deals = self.dictionary["deals"] as? [AnyObject] {
        return deals
      }
      return nil
    }
  }
  
  var latitude: Double? {
    get {
      if let location = self.dictionary["location"] as? NSDictionary {
        if let coordinate = location["coordinate"] as? NSDictionary {
          return (coordinate["latitude"] as Double)
        }
      }
      return 37.7833
    }
  }
  
  var longitude: Double? {
    get {
      if let location = self.dictionary["location"] as? NSDictionary {
        if let coordinate = location["coordinate"] as? NSDictionary {
          return (coordinate["longitude"] as Double)
        }
      }
      return -122.4167
    }
  }
  
  var location: CLLocation {
    get {
      return CLLocation(latitude: self.latitude!, longitude: self.longitude!)
    }
  }
  
  var shortAddress: String {
    get {
      if let location = self.dictionary["location"] as? NSDictionary {
        if let address = location["address"] as? [String] {
          if let neighborhoods = location["neighborhoods"] as? [String] {
            return ", ".join(address + [neighborhoods[0]])
          }
          return ", ".join(address)
        }
      }
      return ""
    }
  }
  
  var displayAddress: String {
    get {
      if let location = self.dictionary["location"] as? NSDictionary {
        if let address = location["display_address"] as? [String] {
          return ", ".join(address)
        }
      }
      return ""
    }
  }
  
  var displayCategories: String {
    get {
      if let categories = self.dictionary["categories"] as? [[String]] {
        return ", ".join(categories.map({ $0[0] }))
      }
      return ""
    }
  }
  
}
