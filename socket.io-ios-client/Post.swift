//
//  Post.swift
//  feed-facebook-socket.io
//
//  Created by Rath Phearun on 12/22/16.
//  Copyright © 2016 Rath Phearun. All rights reserved.
//

import Foundation

class Post{
    var id: String?
    var username: String?
    var text: String?
    var like: Int?
    
    init() {
        
    }
    init(id: String, username: String, text:String, like:Int) {
        self.id = id
        self.like = like
        self.text = text
        self.username = username
    }
}

