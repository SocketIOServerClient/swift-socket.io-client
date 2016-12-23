//
//  FeedCustomCell.swift
//  socket.io-ios-client
//
//  Created by Rath Phearun on 12/23/16.
//  Copyright © 2016 Rath Phearun. All rights reserved.
//

import Foundation
import UIKit

protocol FeedCellDelegate {
    func likeButtonDidClick(post:Post)
    func removeButtonDidClick(post:Post)
}


class FeedCustomCell: UITableViewCell{


    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var statusTextView: UITextView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var post: Post?
    
    var delegate: FeedCellDelegate?
    
    func ConfigureCell(_ post:Post) -> Void {
        self.post = post
        
        usernameLabel.text = "\(post.username!)"
        statusTextView.text = "\(post.text!)"
        likeButton.setTitle("\(post.like!) Likes", for: .normal)
        
    }
    
    @IBAction func onRemoveClick(_ sender: Any) {
        delegate?.removeButtonDidClick(post: self.post!)
    }
    
    @IBAction func onLikeClick(_ sender: Any) {
        delegate?.likeButtonDidClick(post: self.post!)
        
    }
    
}
