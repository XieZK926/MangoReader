//
//  AppProblemsViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/9.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class AppProblemsViewController: UIViewController {
    @IBOutlet weak var myTextView: UIPlaceHolderTextView!
    @IBOutlet weak var linkManTF: UITextField!
    @IBOutlet weak var mainContent: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.placeholder = "请输入反馈问题"
        myTextView.delegate = self
//        let maxCount = 3
//        let photoUploader = PYPhotosView(images: [])
//        photoUploader?.backgroundColor = UIColor.cyan
//        photoUploader?.photosMaxCol = maxCount
//        photoUploader?.imagesMaxCountWhenWillCompose = maxCount
//        photoUploader?.py_x =  CGFloat(PYMargin)
//        photoUploader?.py_y = CGFloat(PYMargin)
//        photoUploader?.py_size = CGSize(width: 80, height: 80)
//        photoUploader?.showDuration = 0.26;
//        photoUploader?.hiddenDuration = 0.26;
//        // 2.1 设置本地图片
////        photoUploader.images = NSMutableArray(array: []);
//        // 3. 设置代理
//        photoUploader?.delegate = self;
//        self.view.addSubview(photoUploader!)
        

//        // 1. 创建本地图片数组
//        NSMutableArray *imagesM = [NSMutableArray array];
//        for (int i = 0; i < arc4random_uniform(4) + 1; i++) {
//            [imagesM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%02d", i + 1]]];
//        }
//
//        // 2.1 设置本地图片
//        PYPhotosView *photosView = [PYPhotosView photosViewWithImages:imagesM];
//
//        // 3. 设置代理
//        photosView.delegate = self;
//
//        // 4. 添加photosView
//        [self.view addSubview:photosView];



        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit(_ sender: Any) {
        XKToastUtil.showLoading(status: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            XKToastUtil.showSuccessToast(status: "提交成功")
            self.navigationController?.popViewController(animated: true)
        }

    }
    

}

extension AppProblemsViewController: PYPhotosViewDelegate, UITextViewDelegate {
    func photosView(_ photosView: PYPhotosView!, didAddImageClickedWithImages images: NSMutableArray!) {
        print(images ?? "-")
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        print(textView.text.count)
        self.countLabel.text = textView.text.count.description  + "/999"
    }
}
