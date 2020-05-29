//
//  PostDetail.swift
//  DcardClone
//
//  Created by Jodie Hu on 2020/5/19.
//  Copyright © 2020 jodiehu. All rights reserved.
//

import Foundation

struct PostDetail:Decodable{
    var title:String
    var createdAt: Date
    var content: String
    var media:[Media]
    
}

struct Media:Decodable {
    var url:URL
}
