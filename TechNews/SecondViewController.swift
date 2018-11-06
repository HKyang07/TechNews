//
//  FirstViewController.swift
//  TechNews
//
//  Created by Felix on 2018/10/19.
//  Copyright © 2018 Felix. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SecondViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:0.95, green:0.50, blue:0.05, alpha:1.0)
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 20)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripVC1") as! StripViewController1
        vc4.suffixUrl = .new
        vc4.stripName = .new
        return [vc4]
    }
    
    
}

