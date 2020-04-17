//
//  MineViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit

class MineViewController: UITableViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarBarTintColor = .white
        self.title = "个人中心"
       
//        idLabel.text = "Id：" + Int(Date().timeIntervalSince1970 / 2).description
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(FeedbackViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(RecordViewController(), animated: true)
        case 2:
           let vc = StaticTextViewController()
           vc.type = .user
           vc.title = "用户协议"
           self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = StaticTextViewController()
            vc.type = .privacy
            vc.title = "隐私政策"
            self.navigationController?.pushViewController(vc, animated: true)

        case 4:
            self.navigationController?.pushViewController(ContactUsViewController(), animated: true)
            
        default:
            break
            
        }
    }

}

