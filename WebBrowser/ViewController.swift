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
    var progressView: UIProgressView!
    var websites = ["github.com/bahasobucovali", "github.com/ssemaatopcu", "linkedin.com/in/sema-topcu-7a73a91b8/?originalSubdomain=tr", "linkedin.com/in/melih-baha-söbücovalı-8339931b3/"]
    
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
       
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //which creates a flexible space. It doesn't need a target or action because it can't be tapped
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)) // it's calling the reload() method on the web view rather than using a method of our own
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        /*  #keyPath allows the compiler to check that your code is correct
         in more complex applications, all calls to addObserver() should be matched with a call to removeObserver() when you're finished observing */
        
        let url = URL(string: "https://" + webSites[0])!
        webView.load(URLRequest(url: url)) //it creates a new URLRequest object from that URL, and gives it to our web view to load
        webView.allowsBackForwardNavigationGestures = true //allows users to swipe from the left or right edge to move backward or forward in their web browsing
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
       
        for webSite in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
       
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
               progressView.progress = Float(webView.estimatedProgress)
           }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
               for website in websites {
                   if host.contains(website) {
                       decisionHandler(.allow)
                       return
                   }
               }
           }

           decisionHandler(.cancel)
       }
        
}

