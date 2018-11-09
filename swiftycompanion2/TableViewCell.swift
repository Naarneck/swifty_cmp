//
//  TableViewCell.swift
//  swiftycompanion2
//
//  Created by Ivan Zelenskyi on 11/6/18.
//  Copyright © 2018 Ivan Zelenskyi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var image_small: UIImageView!
    @IBOutlet weak var xlogin: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image_small.makeRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
