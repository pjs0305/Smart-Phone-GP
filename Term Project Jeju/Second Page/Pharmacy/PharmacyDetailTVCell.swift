//
//  MinbakDetailTVCell.swift
//  Term Project Jeju
//
//  Created by KPUGAME on 15/06/2019.
//  Copyright © 2019 KPUGAME. All rights reserved.
//

import UIKit

class PharmacyDetailTVCell: UITableViewCell {

    @IBOutlet weak var myimage: UIImageView!
    @IBOutlet weak var mytitle: UILabel!
    @IBOutlet weak var mydetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myimage.layer.cornerRadius = 10
        myimage.layer.masksToBounds = true
        myimage.layer.borderWidth = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
