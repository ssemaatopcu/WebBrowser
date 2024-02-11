//
//  ViewController.swift
//  WebBrowser
//
//  Created by Sema Topcu on 2/11/24.
//

import UIKit
import WebKit


class ViewController: UIViewController,
    WKNavigationDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        /* Delegation is what's called a programming pattern – a way of writing code – and it's used extensively in iOS. And for good reason: it's easy to understand, easy to use, and extremely flexible.
         A delegate is one thing acting in place of another, effectively answering questions and responding to events on its behalf.
         In our code, we're setting the web view's navigationDelegate property to self, which means "when any web page navigation happens, please tell me – the current view controller.”
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
       
        let url = URL(string: "https://github.com/ssemaatopcu")!
        webView.load(URLRequest(url: url)) //it creates a new URLRequest object from that URL, and gives it to our web view to load
        webView.allowsBackForwardNavigationGestures = true //allows users to swipe from the left or right edge to move backward or forward in their web browsing
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "github.com/bahasobucovali", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "github.com/ssemaatopcu", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "linkedin.com/in/sema-topcu-7a73a91b8/?originalSubdomain=tr", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "linkedin.com/in/melih-baha-söbücovalı-8339931b3/", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
                     
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

