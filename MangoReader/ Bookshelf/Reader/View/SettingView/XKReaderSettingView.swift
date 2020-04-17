//
//  XKReaderSettingView.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/18.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKReaderSettingView: UIView {
    @IBOutlet weak var desLabel1: UILabel!
    @IBOutlet weak var desLabel2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var smallerBtn: UIButton!
    @IBOutlet weak var biggerBtn: UIButton!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet var colorButtons: [UIButton]!
    
    private var selectedIndex: Int = XKReaderConfig.shared().bgColorIndex
    var readMenu: XKReaderMenu?
    
    class func sharedView() -> XKReaderSettingView{
        return Bundle.main.loadNibNamed("XKReaderSettingView", owner: nil, options: nil)?.last as! XKReaderSettingView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for btn in colorButtons {
            btn.layer.cornerRadius = 13
            btn.layer.masksToBounds = true
            btn.layer.borderColor = UIColor.white.cgColor
        }
        smallerBtn.layer.cornerRadius = 12
        smallerBtn.layer.borderWidth = 1
        smallerBtn.layer.masksToBounds = true
        
        biggerBtn.layer.cornerRadius = 12
        biggerBtn.layer.borderWidth = 1
        biggerBtn.layer.masksToBounds = true
        updateUI()

    }
    
    func updateUI() {
        let config = XKReaderConfig.shared()
        self.backgroundColor = config.reader_menu_color
        if config.bgColorIndex < 6 {
            self.colorButtons[config.bgColorIndex].layer.borderWidth = 2
            let zoomIn = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.colorButtons[config.bgColorIndex].transform = zoomIn

        }
        self.desLabel1.textColor = config.menu_text_color
        self.desLabel2.textColor = config.menu_text_color
        self.fontSizeLabel.textColor = config.menu_text_color
        biggerBtn.layer.borderColor = config.menu_text_color.cgColor
        smallerBtn.layer.borderColor = config.menu_text_color.cgColor
        
        label1.textColor = config.menu_text_color
        label2.textColor = config.menu_text_color
        slider.minimumTrackTintColor = config.themeType == .day ? kColor333 : .white

        
    }
    
    @IBAction func sliderDidChanged(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(slider.value)
    }

    
    /// 放大
    @IBAction func increaseFont(_ sender: Any) {
        let fontSize = XKReaderConfig.shared().fontSize + 2
        if (fontSize > 22) {
            return
        }
        XKReaderConfig.shared().fontSize = fontSize
        XKReaderConfig.shared().save()
        fontSizeLabel.text = String(format: "%.0f", fontSize)
        readMenu?.delegate?.readMenuClickChangeFont(readMenu: readMenu, fontSize: fontSize)
    }
    
    /// 缩小
    @IBAction func decreaseFont(_ sender: Any) {
        let fontSize = XKReaderConfig.shared().fontSize - 2
        if (fontSize < 12) {
            return
        }
        XKReaderConfig.shared().fontSize = fontSize
        XKReaderConfig.shared().save()
        fontSizeLabel.text = String(format: "%.0f", fontSize)
        readMenu?.delegate?.readMenuClickChangeFont(readMenu: readMenu, fontSize: fontSize)

    }
    
    @IBAction func changeBgColor(_ sender: UIButton) {
        let index = sender.tag - 100
        if selectedIndex == index {
            return
        }
        let btn1 = colorButtons[selectedIndex]
        btn1.layer.borderWidth = 0
        let zoomOut = CGAffineTransform(scaleX: 1, y: 1)
        btn1.transform = zoomOut
        let btn2 = colorButtons[index]
        btn2.layer.borderWidth = 2
        let zoomIn = CGAffineTransform(scaleX: 1.2, y: 1.2)
        btn2.transform = zoomIn
//        btn1.width = btn2.width + 4
        selectedIndex = index
        XKReaderConfig.shared().bgColorIndex = index
        readMenu?.delegate?.readMenuClickChangeBgColor(readMenu: readMenu)
    }



}
