//
//  PostListViewController.swift
//  Post
//
//  Created by Aaron Shackelford on 11/18/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //creating instance of PostController to locally use in this class file
    let postController = PostController()
    
    //creating var as UIRefreshControl() to allow it to be used in the rest of the VC class
    var refreshControl = UIRefreshControl()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        
        postTableView.estimatedRowHeight = 45
        postTableView.rowHeight = UITableView.automaticDimension
        
        postTableView.refreshControl = refreshControl
        //adding objc to refresh control
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts { (result) in
            self.reloadTableView()
        }
    }
    
    // MARK: - Actions
    @IBAction func addPostButtonTapped(_ sender: UIBarButtonItem) {
        presentNewPostAlert()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        
        
        cell.textLabel?.text = post.text
        if let timestamp = post.timestamp {
            
            cell.detailTextLabel?.text = "\(post.username) - \(Date(timeIntervalSince1970: timestamp))"
        } else {
            cell.detailTextLabel?.text = "\(post.username)"
        }
        return cell
    }
    
    // MARK: - Custom Methods
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.postTableView.reloadData()
        }
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts { (result) in
            self.reloadTableView()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    //TODO; ENSURE BOTH TEXT FIELDS POPULATE ALERT CONTROLLER
    func presentNewPostAlert() {
        let postAlertController = UIAlertController(title: "New Post", message: nil, preferredStyle: .alert)
        var usernameTextField = UITextField()
        postAlertController.addTextField { (usernameText) in
            usernameText.placeholder = "Enter username"
            usernameTextField = usernameText
        }
        var messageTextField = UITextField()
        postAlertController.addTextField { (messageText) in
            messageText.placeholder = "Enter message"
            messageTextField = messageText
        }
        //TODO; ENSURE ADDNEWPOSTWITH FUNCTION PASSES DATA THROUGH  
        let postAction = UIAlertAction(title: "Post", style: .default) { (postAction) in
            //making sure the fields !nil before passing them through
            guard let username = usernameTextField.text, !username.isEmpty, let text = messageTextField.text, !text.isEmpty else { return }
            self.postController.addNewPostWith(username: username, text: text) { (_) in
                self.reloadTableView()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        postAlertController.addAction(postAction)
        postAlertController.addAction(cancelAction)
        self.present(postAlertController, animated: true)
    }
}
