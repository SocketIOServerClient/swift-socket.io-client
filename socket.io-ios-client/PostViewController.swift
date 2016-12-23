//
//  PostViewController.swift
//  feed-facebook-socket.io
//
//  Created by Rath Phearun on 12/22/16.
//  Copyright © 2016 Rath Phearun. All rights reserved.
//

import UIKit
import SocketIO

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postTableView: UITableView!
    
    var socket = SocketIOClient(socketURL: URL(string: "http://192.168.178.128:3000")!, config: [.log(false), .forcePolling(true), .forceNew(true), .nsp("/post")])

    
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.delegate = self
        postTableView.dataSource = self
        
        //socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        
        socket.on("connect"){ data, ack in
            print("connected to server!")
        }
        
        socket.on("all posts"){ data, ack in
            
            print("all post", data)
            if let data =  data[0] as? [AnyObject]{
                for dic in data{
                    print("1java")
                    if let post = dic as? [String:AnyObject]{
                        print("2java")
                        self.renderView(post)
                    }
                }
            }
            
            self.postTableView.reloadData()
            
        }

        socket.on("new post"){ data, ack in
            print("data", data)
            if let dicPost = data[0] as? [String:AnyObject]{
                self.renderView(dicPost)
                self.postTableView.reloadData()
            }
        }
        
        socket.on("update like"){ data, ack in
            print("data", data)
            let like = data[0] as? Int
            let id = data[1] as? String
            
            let index = self.findIndexById(id!)
            self.posts[index].like = like
            self.postTableView.reloadData()
        }

        socket.on("removed post"){ data, ack in
            print("data", data)
            let id = data[0] as? String
            
            let index = self.findIndexById(id!)
            self.posts.remove(at: index)
            
            self.postTableView.reloadData()
        }

        socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postIndentifier") as? PostCell
        cell?.delegate = self
        cell?.configureCell(post: posts[indexPath.row], index: indexPath.row)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            posts.remove(at: indexPath.row)
            postTableView.reloadData()
        }
    }
    
    
    func renderView(_ post:[String:AnyObject]) -> Void {
        let p = Post()
        p.id = post["id"] as? String
        p.text = post["text"] as? String
        p.username = post["username"] as? String
        p.like = post["like"]! as? Int
        posts.append(p)
    }
    
    
    
    func findIndexById(_ id:String) -> Int {
        let result = posts.index { (post) -> Bool in
            if post.id! == id {
                print("1\(post.text!) == \(id)")
                return true
            }
            print("2\(post.text!) == \(id)")
            return false
        }
        if result==nil{
            return 0
        }
        return result!
    }
}

