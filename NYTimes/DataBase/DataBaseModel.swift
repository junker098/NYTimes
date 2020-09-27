//
//  DataBaseModel.swift
//  NYTimes
//
//  Created by Юрий Могорита on 26.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteModel: Object {
    @objc dynamic var title = ""
    @objc dynamic var author = ""
    @objc dynamic var date = ""
    @objc dynamic var image = Data()
    @objc dynamic var saveArticle = ""
    @objc dynamic var url = ""
}
