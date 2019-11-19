//
//  PostController.swift
//  Post
//
//  Created by Aaron Shackelford on 11/18/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation




class PostController {

    
        //1 URL
        let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
        //SOT
        var posts = [Post]()
    
    //NOT putting a static function according to directions for project, lord help me
    func fetchPosts(reset: Bool = true, completion: @escaping(Result <[Post], PostAPIError>) -> Void) {
        
        //unwrapping url to give it endpoint for json INSIDE the function
        guard let postURL = baseURL else { return completion(.failure(.invalidURL))}
        let getterEndpoint = postURL.appendingPathExtension("json")
        //2 go to internet; data task
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil; request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            //3 handle errors
            if let error = error {
                print("ERROR: \(error), \n---\n \(error.localizedDescription)")
                return completion(.failure(.noPosts))
            }
            //4 unwrap our data
            guard let data = data else { return completion(.failure(.noData))}
            do {
                //5 decode our data
                let decoder = JSONDecoder()
                let postsDictionary = try decoder.decode([String:Post].self, from: data)
                //creating posts array to be appended to through our for-loop
                var posts = [Post]()
                
                for (_, value) in postsDictionary {
                    posts.append(value)
                }
                posts.sort(by: {
                    if let timestamp1 = $0.timestamp, let timestamp2 = $1.timestamp {
                        return timestamp1 > timestamp2
                    } else {
                        return true
                    }
                })
                //sorting posts based on timestamp values
                //adding the sorted posts array to our SOT
                self.posts = posts
                return completion(.success(posts))
            } catch {
                print("ERROR: \(error), \n---\n \(error.localizedDescription)")
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping(Result <Bool, PostAPIError>) -> Void) {
        let post = Post(username: username, text: text)
        var postData: Data
        
        do {
            postData = try JSONEncoder().encode(post)
        } catch {
            print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
            return completion(.failure(.unableToEncode))
        }
        
        guard let postURL = baseURL else { return completion(.failure(.communicationError)) }
        let postEndpoint = postURL.appendingPathExtension("json")
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            //handle errors
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                completion(.failure(.noPosts))
            }
            //unwrap data
            guard let data = data, let readableDataString = String(data: data, encoding: .utf8) else { return completion(.failure(.noData)) }
            print(readableDataString)
            
            self.fetchPosts { (result) in
                completion(.success(true))
            }
        }.resume()
    }
}




enum PostAPIError: LocalizedError {
    case invalidURL
    case communicationError
    case noData
    case unableToDecode
    case unableToEncode
    case noPosts
    
}
