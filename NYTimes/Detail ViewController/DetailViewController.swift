//
//  DetailViewController.swift
//  NYTimes
//
//  Created by Юрий Могорита on 26.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK: - Properties
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    var article: Article?
    var savedHTM: String?
    var savedURL: String?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0
        setupEstimatedProgressObserver()
        loadPage() 
    }
    
    //MARK: - ProgressView progress
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    //MARK: - Save Data
    @IBAction func saveDataInFavorite(_ sender: UIBarButtonItem) {
        let alertController  = UIAlertController(title: "Save", message: "Save to favorite?", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.webView.evaluateJavaScript("document.body.innerHTML") { (value, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                let result = value as? String
                guard let resultString = result else { return }
                DataBaseHelper.shared.saveArticleInDB(self.article, resultString)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func loadPage() {
        if let url = article?.url, !url.isEmpty && NetworkManager.shared.doesTheInternetWork  {
            guard let url = URL(string: url) else { return }
            webView.load(URLRequest(url: url))
        } else if let url = savedURL, !url.isEmpty && NetworkManager.shared.doesTheInternetWork {
            guard let url = URL(string: url) else { return }
            webView.load(URLRequest(url: url))
        } else if let html = savedHTM, !html.isEmpty{
            webView.loadHTMLString(html, baseURL: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Connection is lost", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
        }
    }
}
