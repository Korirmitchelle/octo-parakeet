//
//  LocationTableViewCell.swift
//  Parakeet
//
//  Created by Mitchelle Korir on 07/06/2021.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var placename: UILabel!
    @IBOutlet weak var placeDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
