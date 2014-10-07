//
//  BusinessViewController.swift
//  fresh_yelp
//
//  Created by Wanda Cheung on 10/4/14.
//

import UIKit

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var searchBar: UISearchBar!
    var client: YelpClient!
  
    let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
    let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
    let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
    let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

    var userLocation: UserLocation!
    var results: [Business] = []
    var offset: Int = 0
    var total: Int!
    let limit: Int = 20
    var lastResponse: NSDictionary!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
 
        self.client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)

        self.userLocation = UserLocation()
      
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.text = "restaurants"
        self.navigationItem.titleView = self.searchBar
      
        self.performSearch(self.searchBar.text)
        self.tableView.reloadData()
    }

  final func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == "" {
      self.clearResults()
    }
  }
  
  
  func onResults(results: [Business], total: Int, response: NSDictionary) {
      self.tableView.reloadData()
  }

  func clearResults() {
    self.results = []
    self.offset = 0
    self.onResultsCleared()
  }

  
  
  func onResultsCleared() {
    self.tableView.reloadData()
  }
  
  @IBAction func onTap(sender: AnyObject) {
      view.endEditing(true)
      searchBar.resignFirstResponder()
      self.performSearch(self.searchBar.text)

  }
  
  func performSearch(term: String, offset: Int = 0, limit: Int = 20) {
    self.searchBar.text = term
    
    self.client.searchWithTerm(term, parameters: self.getSearchParameters(), offset: offset, limit: 20, success: {
      (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      self.results = (response["businesses"] as Array).map({
        (business: NSDictionary) -> Business in
        return Business(dictionary: business)
      })
      
      self.total = response["total"] as Int
      self.lastResponse = response as NSDictionary
      self.tableView.reloadData()
      self.onResults(self.results, total: self.total, response: self.lastResponse)
      }, failure: {
        (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        println(error)
    })
  }
  
  func getSearchParameters() -> Dictionary<String, String> {
    var parameters = [
      "ll": "\(userLocation.latitude),\(userLocation.longitude)"
    ]
    for (key, value) in SearchFilters.instance.parameters {
      parameters[key] = value
    }
    return parameters
  }

  
  func searchBarSearchButtonClicked( searchBar: UISearchBar!)
  {
      self.performSearch(self.searchBar.text)
      searchBar.resignFirstResponder()
  }
  
  final func onFiltersDone(controller: FiltersViewController) {
    if self.searchBar.text != "" {
      self.clearResults();
      self.performSearch(self.searchBar.text)
      self.searchBar.text = ""
    }
  }

  
  func synchronize(searchView: BusinessViewController) {
    self.searchBar.text = searchView.searchBar.text
    self.results = searchView.results
    self.total = searchView.total
    self.offset = searchView.offset
    self.lastResponse = searchView.lastResponse
    
    if self.results.count > 0 {
      self.onResults(self.results, total: self.total, response: self.lastResponse)
    } else {
      self.onResultsCleared()
    }
  }
  
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier("businessCell") as businessCell
    
      let business = self.results[indexPath.row]

      if (business.imageURL? != nil) {
          cell.businessImage.setImageWithURL(business.imageURL)
      }
      cell.businessImage.layer.cornerRadius = 9.0
      cell.businessImage.layer.masksToBounds = true
      cell.nameLabel.text = "\(indexPath.row + 1). \(business.name)"
      cell.ratingImage.setImageWithURL(business.ratingImageURL)
      let reviewCount = business.reviewCount
      if (reviewCount == 1) {
          cell.reviewsLabel.text = "\(reviewCount) review"
      } else {
          cell.reviewsLabel.text = "\(reviewCount) reviews"
      }
      
      cell.addressLabel.text = business.shortAddress
      cell.cuisineLabel.text = business.displayCategories
    
      let distance = business.location.distanceFromLocation(self.userLocation.location)
      cell.distLabel.text = String(format: "%.1f mi", distance / 1609.344)
      cell.distLabel.sizeToFit()
    
    
    cell.layoutIfNeeded()
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.destinationViewController is UINavigationController {
      let navigationController = segue.destinationViewController as UINavigationController
      if navigationController.viewControllers[0] is FiltersViewController {
        let controller = navigationController.viewControllers[0] as FiltersViewController
        controller.delegate = self
      }
    }
  }
  
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.results.count
  }
  
  
}
