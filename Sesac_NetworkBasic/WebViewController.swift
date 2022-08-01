//
//  WebViewController.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/07/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    
    static let identity = "WebViewController"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var goBackBtn: UIBarButtonItem!
    @IBOutlet weak var reloadBtn: UIBarButtonItem!
    @IBOutlet weak var goForwardBtn: UIBarButtonItem!
    
    var destinationURL: String = "https://www.apple.com"
    
    //http에 대한 대부분사이트는 차단함.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openWebPage(url: destinationURL)
        searchBar.delegate = self
        
        closeBtn.image = UIImage(systemName: "xmark")
        goBackBtn.image = UIImage(systemName: "arrow.left")
        reloadBtn.image = UIImage(systemName: "arrow.clockwise")
        goForwardBtn.image = UIImage(systemName: "arrow.right")
        
        // 네비게이션 바에 close아이템
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissWebView))
    }
    
    @objc func dismissWebView() {
        self.dismiss(animated: true)
    }
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    @IBAction func tapCloseBtn(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func tapGoBackBtn(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    @IBAction func tapReloadBtn(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    @IBAction func tapGoForwardBtn(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}

extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: "https://" + searchBar.text!)
    }
}
