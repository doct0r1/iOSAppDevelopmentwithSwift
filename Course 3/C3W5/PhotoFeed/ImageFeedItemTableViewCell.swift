//
//  ImageFeedItemTableViewCell.swift
//  PhotoFeed
//
//  Created by Dmitriy Barash on 10/15/2017

import UIKit

class ImageFeedItemTableViewCell: UITableViewCell {


    @IBOutlet weak var itemImageView: UIImageView!

    @IBOutlet weak var itemTitle: UILabel!
    
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
