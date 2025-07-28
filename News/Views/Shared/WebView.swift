//
//  WebView.swift
//  News
//
//  Created by Srikanth Chaitanya Tirukkovalluri on 26/7/2025.
//

import SwiftUI
import WebKit

/// WebViewState captures the state of the WKWebView.
class WebViewState : ObservableObject {
    @Published var url: URL?
    @Published var isLoading = false
    @Published var hasError = false
    @Published var estimatedProgress = 0.0
}

/// WebView hosts WKWebView.
struct WebView: UIViewRepresentable {
    var webViewState : WebViewState
    var url: URL?
        
    // Make and configure the WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // Set the coordinator as the delegate
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        load(url: url, in: webView)
        return webView
    }
    
    fileprivate func load(url:URL?, in webView: WKWebView) {
        if let url = url {
            let req = URLRequest(url: url)
            webView.load(req)
        }
    }

    // Update the WKWebView when the URL changes
    func updateUIView(_ uiView: WKWebView, context: Context) {
        load(url: nil, in: uiView)
    }

    // Create a Coordinator to handle WKWebView delegate methods (optional but recommended)
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        // Example WKNavigationDelegate methods:
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Started loading: \(webView.url?.absoluteString ?? "unknown")")
            parent.webViewState.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading: \(webView.url?.absoluteString ?? "unknown")")
            parent.webViewState.isLoading = false
            self.parent.webViewState.estimatedProgress = 1.0 // Set progress to 100% when loading finishes
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("Failed to load: \(error.localizedDescription)")
            parent.webViewState.isLoading = false
            parent.webViewState.hasError = true
            webView.stopLoading()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Navigation failed: \(error.localizedDescription)")
            parent.webViewState.isLoading = false
            parent.webViewState.hasError = true
            webView.stopLoading()
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard let webView = object as? WKWebView else { return }

            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                DispatchQueue.main.async {
                    self.parent.webViewState.estimatedProgress = webView.estimatedProgress
                }
            }
        }
    }
}
