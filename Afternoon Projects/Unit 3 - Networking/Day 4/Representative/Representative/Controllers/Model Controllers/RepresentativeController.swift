//
//  RepresentativeController.swift
//  Representative
//
//  Created by Aaron Shackelford on 11/20/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class RepresentativeController {
    
    static let baseURL = URL(string: "http://whoismyrepresentative.com")
    
    static func searchRepresentatives(forState state: String, completion: @escaping ([Representative]) -> Void) {
        guard let unwrappedURL = baseURL?.appendingPathComponent("getall_reps_bystate") else { completion([]); return }
        //TODO;
        //cant be the best way to find url; urlcomponents??
        let extURL = unwrappedURL.appendingPathExtension("php")
        //?state=\(state)&output=json
        
        let stateQueryItem = URLQueryItem(name: "state", value: state)
        let outputQueryItem = URLQueryItem(name: "output", value: "json")
        var components = URLComponents(url: extURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [stateQueryItem, outputQueryItem]
        guard let finalURL = components?.url else { return completion([]) }
        
        print(finalURL)
        
    
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            //handle errors
            if let error = error {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                completion([]); return
            }
            guard let data = data,
                let dataString = String(data: data, encoding: .ascii),
                let correctedData = dataString.data(using: .utf8)
                else { completion([]); return }
            
            do {
                let resultsDict = try JSONDecoder().decode([String: [Representative]].self, from: correctedData)
                let repArray = resultsDict["results"]
                completion(repArray ?? [])
            } catch {
                print("ERROR in \(#function) : \(error), \n---\n \(error.localizedDescription)")
                completion([]); return
            }
            
        }.resume()
    }
}
