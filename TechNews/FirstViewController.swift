//
//  FirstViewController.swift
//  TechNews
//
//  Created by Felix on 2018/10/19.
//  Copyright © 2018 Felix. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FirstViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red:1.00, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 18)
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
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripVC1") as! StripViewController1
        vc1.suffixUrl = .top
        vc1.stripName = .top
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripVC1") as! StripViewController1
        vc2.suffixUrl = .ask
        vc2.stripName = .ask
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripVC1") as! StripViewController1
        vc3.suffixUrl = .job
        vc3.stripName = .job
        return [vc1, vc2, vc3]
    }
}

