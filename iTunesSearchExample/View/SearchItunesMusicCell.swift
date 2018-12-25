//
//  SearchItunesMusicCell.swift
//  iTunesSearchExample
//
//  Created by LinChe-Ching on 2018/12/22.
//  Copyright © 2018 Che-ching Lin. All rights reserved.
//

import UIKit
import SDWebImage

final class SearchItunesMusicCell : UITableViewCell {
    
    @IBOutlet weak var artistImageView : UIImageView!
    @IBOutlet weak var artistTitleLabel : UILabel!
    
    var artworkUrl : URL? {
        didSet {
            self.artistImageView.sd_setImage(with: artworkUrl) { (image, error, type, url) in
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
