//
//  WebViewController.swift
//  RentalCar
//
//  Created by Ivan on 03.08.2022.
//

import UIKit
import WebKit
import SnapKit

protocol WebViewDelegate: AnyObject {
    func successPayment()
}

final class WebViewController: UIViewController {
    
    private let requestManger: RequestManager = RequestManagerImp()
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    
    private let order: Order
    
    weak var delegate: WebViewDelegate?
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        webConfiguration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
        loadWebView()
    }

    private func layout() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Оплата"
    }
    
    private func loadWebView() {
        guard let request = requestManger.payment(order: order) else { return }
        webView.load(request)
    }
}

// MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let absoluteString = navigationResponse.response.url?.absoluteString {
            if absoluteString.contains("success") {
                print("absoluteString = \(absoluteString)")
                navigationController?.popViewController(animated: true)
                rentalManager.postOrder(order: order) { _ in }
                delegate?.successPayment()
            }
        }
        
        decisionHandler(.allow)
    }
}
