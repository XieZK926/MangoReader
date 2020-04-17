//
//  StaticTextViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
import WebKit
enum StaticTextType {
    case user
    case privacy
}

class StaticTextViewController: UIViewController {
    var type: StaticTextType = .user
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        let fileName: String = {
            switch type {
            case .user:
                return "user"
            case .privacy:
                return "privacy"
            }
        }()
        guard let bundlePath = Bundle.main.path(forResource: fileName, ofType: "html") else {
            return
        }
        let url = URL(fileURLWithPath: bundlePath)
        let request = URLRequest(url: url)
        webView.load(request)
        // Do any additional setup after loading the view.
    }
    
    lazy var webView: WKWebView = {
       let web =  WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        return web
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
