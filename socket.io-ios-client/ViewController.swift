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

    var socket = SocketIOClient(socketURL: URL(string: "http://192.168.178.128:3000")!, config: [.log(false), .forceWebsockets(true), .nsp("/post")])
    
    var posts = [Post]()

    @IBOutlet weak var statusTextView: UITextView!
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        
        socket.on("connect"){ data, ack in
            print("connected to server!")
        }
        
        socket.on("new post"){ data, ack in
            print("new post", data)
            if let dic = data[0] as? [String:AnyObject]{
                self.renderView(dic)
                self.postTableView.reloadData()
                self.scrollToTop()
            }
        }
        
        socket.on("all posts"){ data, ack in
            print("all post", data)
            if let data =  data[0] as? [AnyObject]{
                for dic in data{
                    if let post = dic as? [String:AnyObject]{
                        self.renderView(post)
                    }
                }
            }
            self.postTableView.reloadData()
        }
        
        socket.on("update like"){ data, ack in
            print("update like", data)
            let like = data[0] as? Int
            let id = data[1] as? String
            
            let index = self.findIndexById(id!)
            
            //if search found!
            if index != -1{
                self.posts[index].like = like
                self.postTableView.reloadData()
            }
        }
        
        socket.on("removed post"){ data, ack in
            print("removed post", data)
            let id = data[0] as? String
            
            let index = self.findIndexById(id!)
            
            //if search found!
            if index != -1{
                self.posts.remove(at: index)
                self.postTableView.reloadData()
            }
        }
        
        socket.connect()
        
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
            socket.emit("remove post", posts[indexPath.row].id!)
        }
    }

    //TODO: button post click
    @IBAction func btnPostClick(_ sender: Any) {
       
        var feed = [String:AnyObject]()
        feed["username"] = "Me" as AnyObject?
        feed["text"] = statusTextView.text as AnyObject?
        
        self.socket.emit("new post", feed)
        
        self.statusTextView.text = ""
    }
    
    
    //TODO: find index by id
    func findIndexById(_ id:String) -> Int {
        let index = posts.index { (post) -> Bool in
            if post.id! == id {
                return true
            }
            return false
        }
        if index == nil{
            return -1
        }
        return index!
    }
    
    func renderView(_ post:[String:AnyObject]) -> Void {
        let p = Post()
        p.id = post["id"] as? String
        p.text = post["text"] as? String
        p.username = post["username"] as? String
        p.like = post["like"]! as? Int
        
        self.posts.insert(p, at: 0)
    }
    
    func scrollToTop() -> Void{
        self.postTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension ViewController: FeedCellDelegate{
    
    func likeButtonDidClick(post: Post) {
        socket.emit("like post", post.id!)
    }
    
    func removeButtonDidClick(post: Post) {
        socket.emit("remove post", post.id!)

    }
}

