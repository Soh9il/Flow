//
//  NewsAPI.swift
//  Flow
//
//  Created by Soheil Sharafzadeh on 02/10/21.
//

import Foundation

class NewsAPI {
    public static let shared = NewsAPI()
        
    private init() {}
    
    func concurrentSearchRequest(keyword1: String, keyword2: String, keyword3: String, completionHandler: @escaping (_ newsFeed: [NewsSource.Article]) -> ()) {
        var newsFeed1: [NewsSource.Article] = []
        var newsFeed2: [NewsSource.Article] = []
        var newsFeed3: [NewsSource.Article] = []

    //        or doing something like this if using one array only, to avoid accessing the resource at the same time
    //        let queue = DispatchQueue(label: "thread-safe-obj", attributes: .concurrent)
    //
    //        // write
    //        queue.async(flags: .barrier) {
    //            // perform writes on data
    //        }
        
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        makeRequest(keyword: keyword1, completionHandler: { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }

            case .success(let articles):
                DispatchQueue.main.async {
                    newsFeed1 = articles
                }
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        makeRequest(keyword: keyword2, completionHandler: { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }

            case .success(let articles):
                DispatchQueue.main.async {
                    newsFeed2 = articles
                }
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        makeRequest(keyword: keyword3, completionHandler: { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
                
            case .success(let articles):
                DispatchQueue.main.async {
                    newsFeed3 = articles
                }
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
                completionHandler(newsFeed1+newsFeed2+newsFeed3)
        }
    }

    func makeRequest(keyword: String, completionHandler: @escaping (Result<[NewsSource.Article], Error>) -> Void) {
        
        var newsFeed: [NewsSource.Article] = []
        var errorMessage = ""

        var request = URLRequest(url: APIEndPoints.search(keyword: keyword)!)
        request.httpMethod = "GET"
        request.addValue(ApiConfig.APIKey, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            
            if let error = error {
                completionHandler(.failure(error))
                return
            }
                                    
            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let rawFeed = try decoder.decode(NewsSource.self, from: data)
                newsFeed = rawFeed.articles
                print(newsFeed)
                
                completionHandler(.success(rawFeed.articles))
            } catch let decodeError as NSError {
                errorMessage += "Decoder error: \(decodeError.localizedDescription)"
                print(errorMessage)
                completionHandler(.failure(decodeError))
                return
            }
        })
        
        task.resume()
    }
}
