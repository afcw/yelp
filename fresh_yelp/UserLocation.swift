//
//  UserLocation.swift
//  fresh_yelp
//
//  Created by Wanda Cheung on 10/6/14.
//

import CoreLocation

class UserLocation {
  
  var currentLocationStr : String!
  var currentLocation : CLLocation {
    didSet {
      CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error)->Void in
        if (error != nil) {
          println("Reverse geocoder failed with error = " + error.localizedDescription)
          return
        }
        
        if placemarks.count > 0 {
          let placemark = placemarks[0] as CLPlacemark
          
          if (placemark.locality != nil && placemark.administrativeArea != nil) {
            self.currentLocationStr = "\(placemark.locality),\(placemark.administrativeArea)"
          }
        } else {
          println("Problem with the data received from geocoder")
        }
      })
    }
  }
  
  init() {
    currentLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
    currentLocationStr = "San Francisco, CA"
  }
  
  var latitude: Double {
    get {
      return self.currentLocation.coordinate.latitude
    }
  }
  
  var longitude: Double {
    get {
      return self.currentLocation.coordinate.longitude
    }
  }
  
  var location: CLLocation {
    get {
      return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
  }
  
  
}
