//
//  ListArticleModel.swift
//  NYTimes
//
//  Created by Юрий Могорита on 26.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation

struct ListArticleModel: Decodable {
    
    let results: [Article]?
    
    enum CodingKeys: String, CodingKey {
      case results
    }
}

struct Article: Decodable {
    let url: String
    let title: String
    let publishedDate: String
    let byline: String
    let media: [Media]
    
    enum CodingKeys: String, CodingKey {
        case url
        case title
        case publishedDate = "published_date"
        case byline
        case media
    }
}

struct Media: Decodable {
    let mediaData: [Image]
    
    enum CodingKeys: String, CodingKey {
    case mediaData = "media-metadata"
    }
}

struct Image: Decodable {
    
    let url: String?
    
    enum CodingKeys: String, CodingKey {
    case url
    }
}
