//
//  FlickrPhoto.swift
//  FlickrShowcase
//
//  Created by ShengHua Wu on 30/05/2017.
//  Copyright © 2017 ShengHua Wu. All rights reserved.
//

import Foundation

// MARK: - Serialization Error
enum SerializationError: Error {
    case missing(String)
}

// MARK: - Flickr Photo
struct FlickrPhoto {
    let flickrID: String
    let farm: Int
    let server: String
    let secret: String
}

typealias JSONDictionary = [String : Any]

extension FlickrPhoto {
    init(json: JSONDictionary) throws {
        guard let flickrID = json["id"] as? String else {
            throw SerializationError.missing("id")
        }
        
        guard let farm = json["farm"] as? Int else {
            throw SerializationError.missing("farm")
        }
        
        guard let server = json["server"] as? String else {
            throw SerializationError.missing("server")
        }
        
        guard let secret = json["secret"] as? String else {
            throw SerializationError.missing("secret")
        }
        
        self.flickrID = flickrID
        self.farm = farm
        self.server = server
        self.secret = secret
    }
}

func flickrPhotos(at page: Int, for keyword: String) -> Resource<[FlickrPhoto]> {
    let encodedKeyword = keyword.urlEncodedString()
    let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&page=\(page)&text=\(encodedKeyword)")!
    
    return Resource(url: url) { (json) -> [FlickrPhoto] in
        guard let dictionary = json as? JSONDictionary,
            let photoDict = dictionary["photos"] as? JSONDictionary,
            let photos = photoDict["photo"] as? [JSONDictionary] else {
            throw SerializationError.missing("photo")
        }
        
        return try photos.map(FlickrPhoto.init)
    }
}

// MARK: - String Extension
extension String {
    func urlEncodedString(_ encodeAll: Bool = false) -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        if !encodeAll {
            allowedCharacterSet.insert(charactersIn: "[]")
        }
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}
