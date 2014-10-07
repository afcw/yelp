//
//  businessCell.swift
//  fresh_yelp
//
//  Created by Wanda Cheung on 10/4/14.
//

import UIKit

class businessCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var ratingImage: UIImageView!
  @IBOutlet weak var businessImage: UIImageView!
  @IBOutlet weak var reviewsLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var distLabel: UILabel!
  @IBOutlet weak var cuisineLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
