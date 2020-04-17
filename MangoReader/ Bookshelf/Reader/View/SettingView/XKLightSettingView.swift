//
//  XKLightSettingView.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/18.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKLightSettingView: UIView {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    class func sharedView() -> XKLightSettingView{
        return Bundle.main.loadNibNamed("XKLightSettingView", owner: nil, options: nil)?.last as! XKLightSettingView
    }
    
    override func awakeFromNib() {
        updateUI()
    }
    
    @IBAction func sliderDidChanged(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(slider.value)
    }
    
    func updateUI() {
        let config = XKReaderConfig.shared()
        self.backgroundColor = config.reader_menu_color
        label1.textColor = config.menu_text_color
        label2.textColor = config.menu_text_color
        slider.minimumTrackTintColor = config.themeType == .day ? kColor333 : .white
//        slider.maximumTrackTintColor = config.themeType == .day ? kColorLine

    }
    
}
