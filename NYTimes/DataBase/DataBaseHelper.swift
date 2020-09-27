//
//  DataBaseHelper.swift
//  NYTimes
//
//  Created by Юрий Могорита on 26.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseHelper {
    
    private let realm = try! Realm()    
    static let shared = DataBaseHelper()
    
    private init() {}
    
    //MARK: - Save data in Realm
    
    func saveArticleInDB(_ article: Article?, _ stringHTML: String) {
        let list = FavoriteModel()
        guard let article = article else { return }
        list.title = article.title
        list.author = article.byline
        list.date = article.publishedDate
        list.url = article.url
        list.saveArticle = stringHTML
        if article.media.last?.mediaData.last?.url != nil {
            guard let stringUrl = article.media.last?.mediaData.last?.url else { return }
            guard let urlData = URL(string: stringUrl) else { return }
            guard let data = try? Data(contentsOf: urlData) else { return }
            list.image = data
        } else {
            let image = UIImage(named: "nytimes_placeholder")
            guard let imgData =  image?.pngData() else { return }
            list.image = imgData
        }
        try! realm.write {
            realm.add(list)
        }
    }
    
    //MARK: - Delete data from Realm
    
    func deleteDataFromRealm(_ article: FavoriteModel) {
        try! realm.write {
            realm.delete(article)
        }
    }
    
    
    //MARK: - Get data from Realm
    
    func getDataFromDB() -> Results<FavoriteModel> {
        return realm.objects(FavoriteModel.self)
    }
    
}
