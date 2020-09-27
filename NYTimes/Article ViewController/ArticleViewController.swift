//
//  MostEmailedViewController.swift
//  NYTimes
//
//  Created by Юрий Могорита on 26.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import AlamofireImage


class ArticleViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var articles: [Article]?
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTab()
    }
    
    //MARK: - Methods
    func checkTab() {
        if tabBarController?.selectedIndex == 0 {
            request(category: AssemblyURL.emailed)
            print("tabBar0")
        } else if tabBarController?.selectedIndex == 1 {
            request(category: AssemblyURL.viewed)
            print("tabBar1")
        } else if tabBarController?.selectedIndex == 2 {
            request(category: AssemblyURL.shared)
            print("tabBar2")
        }
    }
    
    func request(category: AssemblyURL) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        NetworkManager.shared.sendRequest(url: AssemblyURL.bodyURL.rawValue + category.rawValue + AssemblyURL.apiKey.rawValue) { result in
            switch result {
            case .success(let listArticles):
                self.articles = listArticles.results
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            case .failure(let message):
                self.showAlert(message: message.rawValue)
            }
        }
    }
}

func setValueInCell(_ cell: ArticleTableViewCell, _ article: Article ) {
    cell.articleLabel.text = article.title
    cell.authorLabel.text = article.byline
    cell.publishedDateLabel.text = article.publishedDate
    cell.backgroundColor = .clear
    if article.media.first?.mediaData.last?.url != nil {
        if let url = URL(string: (article.media.first?.mediaData.last?.url)!) {
            cell.articleImage.af.setImage(withURL: url)
        }
    } else {
        cell.articleImage.image = UIImage(named: "nytimes_placeholder")
    }
}


//MARK: - UITableViewDataSource

extension ArticleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: String(describing: ArticleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ArticleTableViewCell.self))
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleTableViewCell.self), for: indexPath) as? ArticleTableViewCell else { return UITableViewCell()}
        guard let article = articles?[indexPath.row] else { return UITableViewCell()}
        setValueInCell(cell, article)
        
        return cell
    }
}

extension ArticleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let article = articles?[indexPath.row] else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "detailVC") as DetailViewController
        vc.article = article
        navigationController?.show(vc, sender: self)
    }
}

