//
//  ViewController.swift
//  socket.io-ios-client
//
//  Created by Rath Phearun on 12/23/16.
//  Copyright © 2016 Rath Phearun. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusTextView: UITextView!
    var posts = [Post]()
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        for i in 1...10{
            let post = Post()
            post.id = "sid \(i)"
            post.text = "Helloworld \(i)"
            post.username = "Me\(i)"
            post.like = i
            
            posts.append(post)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedIndentifier", for: indexPath) as? FeedCustomCell
        cell?.delegate = self
        cell?.ConfigureCell(posts[indexPath.row])
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            posts.remove(at: indexPath.row)
            postTableView.reloadData()
        }
    }

    
    @IBAction func btnPostClick(_ sender: Any) {
   
        print("Button Post Clicked!")
    
    }

}

extension ViewController: FeedCellDelegate{
    func likeButtonDidClick(post: Post) {
        print("Button Like Clicked\(post)")
    }
    
    func removeButtonDidClick(post: Post) {
        print("Button Remove Clicked\(post)")

    }
}

