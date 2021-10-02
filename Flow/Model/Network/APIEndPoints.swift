//
//  APIEndPoints.swift
//  Flow
//
//  Created by Soheil Sharafzadeh on 02/10/21.
//

import Foundation

struct APIEndPoints {

    static func everything() -> String! {
        return "\(ApiConfig.baseUrl)/everything"
    }
    
    //Search URL with keyword
    static func search(keyword: String) -> URL?  {
        var everythingUrl = URLComponents(string: APIEndPoints.everything())

        let queryItems = [URLQueryItem(name: "q", value: keyword), URLQueryItem(name: "from", value: "2021-10-02"), URLQueryItem(name: "sortBy", value: "popularity")]
        everythingUrl?.queryItems = queryItems;
        return everythingUrl?.url
    }
}
