//
//  ContactUsViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
import MessageUI
class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var copyQQBtn: UIButton!
    @IBOutlet weak var copyEmailBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系方式"
        copyQQBtn.layer.cornerRadius = 15
        copyQQBtn.layer.masksToBounds = true
        copyQQBtn.layer.borderColor = kColor333.cgColor
        copyQQBtn.layer.borderWidth = 1
        
        copyEmailBtn.layer.cornerRadius = 15
        copyEmailBtn.layer.masksToBounds = true
        copyEmailBtn.layer.borderColor = kColor333.cgColor
        copyEmailBtn.layer.borderWidth = 1

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func copyQQ(_ sender: Any) {
        let pastboard = UIPasteboard.general
        pastboard.string = "1006110874"
        XKToastUtil.showSuccessToast(status: "复制成功")
    }
    
     @IBAction func copyEmail(_ sender: Any) {
    //        let pastboard = UIPasteboard.general
    //        pastboard.string = "fengyinglin88@163.com"
    //        XKToastUtil.showSuccessToast(status: "复制成功")
            if MFMailComposeViewController.canSendMail() {
             //注意这个实例要写在if block里，否则无法发送邮件时会出现两次提示弹窗（一次是系统的）
             let mailComposeViewController = configuredMailComposeViewController()
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
             self.showSendMailErrorAlert()
            }
        }
        
        func showSendMailErrorAlert() {

            let sendMailErrorAlert = UIAlertController(title: "无法发送邮件", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
            sendMailErrorAlert.addAction(UIAlertAction(title: "确定", style: .default) { _ in })
            self.present(sendMailErrorAlert, animated: true)
        }
        
        func configuredMailComposeViewController() -> MFMailComposeViewController {
            
             let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
             //设置邮件地址、主题及正文
             mailComposeVC.setToRecipients(["fengyinglin88@163.com"])
             mailComposeVC.setSubject("小笔阅读反馈")
             mailComposeVC.setMessageBody("", isHTML: false)
             return mailComposeVC
        }

        private func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
                
         switch result {
         case .cancelled:
          print("取消发送")
         case .sent:
          print("发送成功")
         default:
          break
         }
            self.dismiss(animated: true, completion: nil)
                
        }
}
