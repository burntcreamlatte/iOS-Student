//
//  PostController.swift
//  Post
//
//  Created by Aaron Shackelford on 11/18/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation




class PostController {

    static func fetchPosts(completion: @escaping (Result <[Post], PostError>) -> Void) {
        //1 URL
        guard let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts") else { return completion(.failure(.invalidURL)) }
        let getterEndpoint = baseURL.appendingPathComponent(".json")
        //2 go to internet; data task
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil; request.httpMethod = "GET"
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            //3 handle errors
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                return completion(.failure(.communicationError))
            }
            //4 unwrap our data
            guard let data = data else { return completion(.failure(.noData))}
            do {
                //5 decode our data
                let decoder = JSONDecoder()
                let postsDictionary = try decoder.decode([String:Post].self, from: data)
                
                var posts = [Post]()
                
                for (_, value) in postsDictionary {
                    posts.append(value)
                }
                posts.sort(by: { $0.timestamp > $1.timestamp})
                return completion(.success(posts))
                
            } catch {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
            }
        }.resume()
    }
}


enum PostError: LocalizedError {
    case invalidURL
    case communicationError
    case noData
    case unableToDecode
    case noPosts
}
