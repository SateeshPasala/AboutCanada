//
//  Networking.swift
//  AboutCanada
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.

import UIKit

/// Result enum is a generic for any type of value
/// with success and failure case

public enum Result<T> {
    case success(T)
    case failure(Error)
}

final class Networking: NSObject {
    
    // MARK: - Private functions
    private static func getData(url: URL,
                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()

    }
    
    
    // MARK: - Public functions
    
    /// fetchData function will fetch the canda facts and returns
    /// Result<CellData> as completion handler
    public static func fetchData(shouldFail: Bool = false, completion: @escaping (Result<CellData>) -> Void) {
        var urlString: String?
        if shouldFail {
            urlString =  EndPoints.test.rawValue
        } else {
            urlString =  EndPoints.prod.rawValue
        }
        
        guard let mainUrlString = urlString,  let url = URL(string: mainUrlString) else { return }
        
        Networking.getData(url: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else { return }
            
            do {
                /// if percentage characters are present direct utf8 will not work
                let asciiEncodedString  =  String(data: data, encoding: .ascii)!
                let encodedData = asciiEncodedString.data(using: .utf8)!
                let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .millisecondsSince1970
                let json = try decoder.decode(CellData.self, from: encodedData)
                completion(.success(json))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    /// downloadImage function will download the thumbnail images
    /// returns Result<Data> as completion handler
    public static func downloadImage(url: URL,
                                     completion: @escaping (Result<Data>) -> Void) {
        if (url.absoluteString == ""){
            completion(.failure(Error.self as! Error))
            return
        }
        
        Networking.getData(url: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }
    }
}

