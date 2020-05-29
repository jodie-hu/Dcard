//
//  PostTableViewCell.swift
//  DcardClone
//
//  Created by Jodie Hu on 2020/5/9.
//  Copyright © 2020 jodiehu. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var genderIcon: UIImageView!
    @IBOutlet weak var forumNameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
