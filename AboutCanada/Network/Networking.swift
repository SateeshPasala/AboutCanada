//
//  Networking.swift
//  AboutCanada
//
//  Created by Veera Venkata Sateesh Pasala on 31/10/20.
//  Copyright © 2020 Veera Venkata Sateesh Pasala. All rights reserved.

import UIKit

/// Result enum is a generic for any type of value
/// with success and failure case

public var openData = """
{
"title":"About Canada",
"rows":[
    {
    "title":"Beavers",
    "description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
    "imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
    },
    {
    "title":"Flag",
    "description":null,
    "imageHref":"http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png"
    },
    {
    "title":"Transportation",
    "description":"It is a well known fact that polar bears are the main mode of transportation in Canada. They consume far less gas and have the added benefit of being difficult to steal.",
    "imageHref":"http://1.bp.blogspot.com/_VZVOmYVm68Q/SMkzZzkGXKI/AAAAAAAAADQ/U89miaCkcyo/s400/the_golden_compass_still.jpg"
    },
    {
    "title":"Hockey Night in Canada",
    "description":"These Saturday night CBC broadcasts originally aired on radio in 1931. In 1952 they debuted on television and continue to unite (and divide) the nation each week.",
    "imageHref":"http://fyimusic.ca/wp-content/uploads/2008/06/hockey-night-in-canada.thumbnail.jpg"
    },
    {
    "title":"Eh",
    "description":"A chiefly Canadian interrogative utterance, usually expressing surprise or doubt or seeking confirmation.",
    "imageHref":null
    },
    {
    "title":"Housing",
    "description":"Warmer than you might think.",
    "imageHref":"http://icons.iconarchive.com/icons/iconshock/alaska/256/Igloo-icon.png"
    },
    {
    "title":"Public Shame",
    "description":" Sadly it's true.",
    "imageHref":"http://static.guim.co.uk/sys-images/Music/Pix/site_furniture/2007/04/19/avril_lavigne.jpg"
    },
    {
    "title":null,
    "description":null,
    "imageHref":null
    },
    {
    "title":"Space Program",
    "description":"Canada hopes to soon launch a man to the moon.",
    "imageHref":"http://files.turbosquid.com/Preview/Content_2009_07_14__10_25_15/trebucheta.jpgdf3f3bf4-935d-40ff-84b2-6ce718a327a9Larger.jpg"
    },
    {
    "title":"Meese",
    "description":"A moose is a common sight in Canada. Tall and majestic, they represent many of the values which Canadians imagine that they possess. They grow up to 2.7 metres long and can weigh over 700 kg. They swim at 10 km/h. Moose antlers weigh roughly 20 kg. The plural of moose is actually 'meese', despite what most dictionaries, encyclopedias, and experts will tell you.",
    "imageHref":"http://caroldeckerwildlifeartstudio.net/wp-content/uploads/2011/04/IMG_2418%20majestic%20moose%201%20copy%20(Small)-96x96.jpg"
    },
    {
    "title":"Geography",
    "description":"It's really big.",
    "imageHref":null
    },
    {
    "title":"Kittens...",
    "description":"Éare illegal. Cats are fine.",
    "imageHref":"http://www.donegalhimalayans.com/images/That%20fish%20was%20this%20big.jpg"
    },
    {
    "title":"Mounties",
    "description":"They are the law. They are also Canada's foreign espionage service. Subtle.",
    "imageHref":"http://3.bp.blogspot.com/__mokxbTmuJM/RnWuJ6cE9cI/AAAAAAAAATw/6z3m3w9JDiU/s400/019843_31.jpg"
    },
    {
    "title":"Language",
    "description":"Nous parlons tous les langues importants.",
    "imageHref":null
    }
]
}
""".data(using: .utf8)!
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
            urlString = "www.google.com"
        } else {
            urlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        }
        
        guard let mainUrlString = urlString,  let url = URL(string: mainUrlString) else { return }
        
        Networking.getData(url: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else { return }
            
            do {
                let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .millisecondsSince1970
                let json = try decoder.decode(CellData.self, from: openData)
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
