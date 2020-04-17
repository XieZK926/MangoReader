//
//  BookRegisterViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/9.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class BookRegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirm(_ sender: Any) {
        XKToastUtil.showLoading(status: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XKToastUtil.showSuccessToast(status: "提交成功")
            self.navigationController?.popViewController(animated: true)
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

