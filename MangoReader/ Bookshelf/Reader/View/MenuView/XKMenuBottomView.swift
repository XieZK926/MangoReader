//
//  XKMenuBottomView.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/17.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
class XKMenuBottomView: UIView {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lastBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var catalogueImage: UIImageView!
    @IBOutlet weak var cataloguelabel: UILabel!
    
    @IBOutlet weak var nightImage: UIImageView!
    @IBOutlet weak var nightlabel: UILabel!
    
    @IBOutlet weak var lightImage: UIImageView!
    @IBOutlet weak var lightlabel: UILabel!
    
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var settinglabel: UILabel!
    
    var isNightType: Bool = XKReaderConfig.shared().themeType == .night
    
    @objc weak var readMenu: XKReaderMenu?
    
    class func sharedView() -> XKMenuBottomView{
        return Bundle.main.loadNibNamed("XKMenuBottomView", owner: nil, options: nil)?.last as! XKMenuBottomView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    
    func updateUI() {
        let config = XKReaderConfig.shared()
        isNightType = config.themeType == .night
        self.backgroundColor = config.reader_menu_color
//        readMenu?.cover.alpha = CGFloat(truncating: NSNumber(value: isNightType))
        slider.minimumTrackTintColor = config.themeType == .day ? kColor333 : .white
        lastBtn.setTitleColor(config.menu_text_color, for: .normal)
        nextBtn.setTitleColor(config.menu_text_color, for: .normal)
        cataloguelabel.textColor = config.menu_text_color
        nightlabel.textColor =  config.menu_text_color
        lightlabel.textColor = config.menu_text_color
        settinglabel.textColor = config.menu_text_color
        if (isNightType) {
            catalogueImage.image = UIImage(named: "muluhei")
            nightImage.image = UIImage(named: "baitian")
            lightImage.image = UIImage(named: "light_white")
            settingImage.image = UIImage(named: "icon_setting_light")
            nightlabel.text = "日间"
        } else {
            catalogueImage.image = UIImage(named: "mulu")
            nightImage.image = UIImage(named: "night")
            lightImage.image = UIImage(named: "light_black")
            settingImage.image = UIImage(named: "icon_setting")
            nightlabel.text = "夜间"
        }
//        self.slider.value = 3/400
    }
    
    
    


    
    

}

//MARK: 点击事件

extension XKMenuBottomView {
    /// 点击上一章
    @IBAction func lastChapterDidClicked(_ sender: Any) {
        readMenu?.delegate?.readMenuClickLastChapter(readMenu: readMenu)
    }
    
    /// 点击下一章
    @IBAction func nextChapterDidClicked(_ sender: Any) {
        readMenu?.delegate?.readMenuClickNextChapter(readMenu: readMenu)
    }
    /// 滑动选章节
    @IBAction func sliderChanged(_ sender: UISlider) {
//        1/400
    }

    
    /// 点击目录
    @IBAction func clickedCatalogue(_ sender: Any) {
        readMenu?.delegate?.readMenuClickCatalogue(readMenu: readMenu)
    }
    
    /// 点击e日夜间
    @IBAction func clickedNight(_ sender: Any) {
        isNightType = !isNightType
        XKReaderConfig.shared().themeType = isNightType ? .night : .day
        XKReaderConfig.shared().bgColorIndex = isNightType ? 6 : 0
        XKReaderConfig.shared().save()
        readMenu?.delegate?.readMenuClickDayAndNight(readMenu: readMenu)
        readMenu?.delegate?.readMenuClickChangeBgColor(readMenu: readMenu)
        self.updateUI()
        readMenu?.topView.updateUI()
        readMenu?.lightnessView.updateUI()
        readMenu?.settingView.updateUI()
    }
    
    /// 点击亮度
    @IBAction func clickedLightness(_ sender: Any) {
        readMenu?.showTopView(isShow: false, animated: true)
        readMenu?.showBottomView(isShow: false, animated: true)
        readMenu?.showLightnessView(isShow: true, animated: true)
    }
    
    /// 点击设置
    @IBAction func clickedSetting(_ sender: Any) {
        readMenu?.showTopView(isShow: false, animated: true)
        readMenu?.showBottomView(isShow: false, animated: true)
        readMenu?.showSettingView(isShow: true, animated: true)
    }
    
    
}
