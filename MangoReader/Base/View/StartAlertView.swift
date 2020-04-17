//
//  StartAlertView.swift
//  MangoReader
//
//  Created by rober_x on 2020/3/3.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
protocol StartAlertViewDelegate {
    func gotoStaicViewWith(type: StaticTextType)
}
class StartAlertView: UIView {
    
    @IBOutlet weak var disBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!

    
    var delegate: StartAlertViewDelegate?
    
    class func sharedView() -> StartAlertView {
        return Bundle.main.loadNibNamed("StartAlertView", owner: nil, options: nil)?.last as! StartAlertView
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
        
        disBtn.layer.cornerRadius = 15
        disBtn.layer.masksToBounds = true
        agreeBtn.layer.cornerRadius = 15
        agreeBtn.layer.masksToBounds = true
    }
    
    @IBAction func disAgree(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func agree(_ sender: Any) {
        XKModal.shared.hidden(animated: true)
        XKUserDefaults.setBool(true, IS_FIRST_ENTER)
    }
    
    @IBAction func gotoPage1(_ sender: Any) {
        self.delegate?.gotoStaicViewWith(type: .user)
    }
    
    @IBAction func gotoPage2(_ sender: Any) {
        self.delegate?.gotoStaicViewWith(type: .privacy)
      }

}
