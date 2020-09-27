//
//  NetworkManager.swift
//  NYTimes
//
//  Created by Юрий Могорита on 26.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation
import Alamofire

enum AssemblyURL: String {
    case bodyURL = "https://api.nytimes.com/svc/mostpopular/v2/"
    case emailed = "emailed/30.json?"
    case shared = "shared/30.json?"
    case viewed = "viewed/30.json?"
    case apiKey = "api-key=m3RmalAIu2moghML3RBxotoAVnAn7q5A"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    var doesTheInternetWork: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    func sendRequest(url: String, completion: @escaping(_ listArticleModel: Result<ListArticleModel, ErrorMessage>) -> Void) {
        if doesTheInternetWork {
            guard let url = URL(string: url) else { return }
            AF.request(url).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print(value)
                    guard let data = response.data else { return }
                    
                    do {
                        let list = try JSONDecoder().decode(ListArticleModel.self, from: data)
                        completion(.success(list))
                        
                    } catch {
                        completion(.failure(.invalidData))
                    }
                case .failure:
                    completion(.failure(.unableToComplete))
                }
            }
        } else {
            completion(.failure(.noInternetConnection))
        }
    }
}
