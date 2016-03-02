//
//  ItemCell.swift
//  j131.tk
//
//  Created by Daniel on 16/3/2.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadImage(isFolder: Bool) {
        self.itemImage.image = UIImage(named: isFolder ? "folderImg" : "fileImg");
    }
}
