//
//  SVGView.swift
//  fakestagram
//
//  Created by LuisE on 3/16/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import UIKit
import WebKit

class SVGView: UIView, WKNavigationDelegate {
    let webSVGView: WKWebView = {
        let wkv = WKWebView()
        wkv.scrollView.isScrollEnabled = false
        wkv.translatesAutoresizingMaskIntoConstraints = false
        return wkv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        webSVGView.navigationDelegate = self
        addSubview(webSVGView)
        NSLayoutConstraint.activate([
            webSVGView.topAnchor.constraint(equalTo: self.topAnchor),
            webSVGView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webSVGView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webSVGView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }

    func loadContent(from url: URL) {
        let req = URLRequest(url: url)
        webSVGView.load(req)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Hard coded offset value to center svg
        webView.evaluateJavaScript("window.scrollTo(385,0)", completionHandler: nil)
    }
}
