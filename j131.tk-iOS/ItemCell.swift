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
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cancelButton: UIButton!
    private var cancelButtonDownEventHandler: () -> Void;
    
    required init?(coder aDecoder: NSCoder) {
        self.cancelButtonDownEventHandler = {};
        super.init(coder: aDecoder);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.progressView.hidden = true;
        self.cancelButton.hidden = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadImage(isFolder: Bool) {
        self.itemImage.image = UIImage(named: isFolder ? "folderImg" : "fileImg");
    }
    
    func registerCancelButtonDownEvent(handler: () -> Void) {
        self.cancelButtonDownEventHandler = handler;
    }
    
    @IBAction func cancelButtonDown(sender: AnyObject) {
        cancelButtonDownEventHandler();
    }
    
    func startDownload() {
        self.progressView.progress = 0;
        self.progressView.hidden = false;
        self.cancelButton.hidden = false;
    }
    
    func endDownload() {
        self.progressView.progress = 0;
        self.progressView.hidden = true;
        self.cancelButton.hidden = true;
    }
}
