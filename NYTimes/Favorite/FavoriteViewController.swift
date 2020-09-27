//
//  FavoriteViewController.swift
//  NYTimes
//
//  Created by Юрий Могорита on 26.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {
    
    //MARK: - Properties
    
    var articleList: Results<FavoriteModel>!
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleList = DataBaseHelper.shared.getDataFromDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Load data in cell
    
    func loadDataInCell(cell: ArticleTableViewCell, article: FavoriteModel) {
        cell.articleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.publishedDateLabel.text = article.date
        cell.articleImage.image = UIImage(data: article.image)
    }
    
    //MARK: - Delete data
    
    func deleteData(_ indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete the article?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            let article = self.articleList[indexPath.row]
            DataBaseHelper.shared.deleteDataFromRealm(article)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        tableView.register(UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as! ArticleTableViewCell
        let article = articleList[indexPath.row]
        loadDataInCell(cell: cell, article: article)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension FavoriteViewController: UITableViewDelegate {
    
    //Delete favorite data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteData(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articleList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "detailVC") as DetailViewController
        vc.savedHTM = article.saveArticle
        vc.savedURL = article.url
        navigationController?.show(vc, sender: self)
    }
}
