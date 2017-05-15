//
//  BookItemTableViewCell.swift
//  bookAPI
//
//  Created by Dana Goldberg on 4/11/17.
//  Copyright © 2017 Dana Goldberg. All rights reserved.
//

import UIKit

class BookItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
