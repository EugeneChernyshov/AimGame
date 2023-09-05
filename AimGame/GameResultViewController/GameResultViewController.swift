//
//  GameResultViewController.swift
//  AimGame
//
//  Created by mac on 9/4/23.
//

import UIKit
import WebKit

class GameResultViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    //MARK: - Stored property
    var urlString: String?
    
    //MARK: - init
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        if isFirstStartingGame() {
            UserDefaults.standard.set(true, forKey: "isFirstGame")
            DispatchQueue.main.async {
                self.showInfoPopup()
            }
        }
    }
    
    //MARK: - Tutorial popup func 
    func isFirstStartingGame() -> Bool {
        if UserDefaults.standard.bool(forKey: "isFirstGame") {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "isFirstGame")
            return true
        }
    }
    
    func showInfoPopup() {
        let alert = UIAlertController(title: "Aim game tutorial", message: "You need to catch aim 10 times in 7 seconds.The aim appears in a random place. If you succeed, you will win, good luck!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IBActions
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
