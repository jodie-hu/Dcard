//
//  Post.swift
//  DcardClone
//
//  Created by Jodie Hu on 2020/5/10.
//  Copyright © 2020 jodiehu. All rights reserved.
//

import Foundation

struct Post:Decodable {
    var id: Int
    var title: String
    var excerpt: String
    var likeCount: Int
    var commentCount: Int
    var gender: String
    var forumName: String
    var school: String?
    var mediaMeta: [MediaMeta]
}

struct MediaMeta:Decodable{
    var url: URL
}
