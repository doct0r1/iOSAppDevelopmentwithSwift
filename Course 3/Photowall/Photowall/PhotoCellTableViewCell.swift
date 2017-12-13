//
//  PhotoCellTableViewCell.swift
//  Photowall
//
//  Created by Ali TANIRLAR on 9.08.2017.
//  Copyright © 2017 Inohive. All rights reserved.
//

import UIKit

class PhotoCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoSmallImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    weak var dataTask: NSURLSessionDataTask?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
