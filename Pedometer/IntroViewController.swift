//
//  IntroViewController.swift
//  Pedometer
//
//  Created by Kravis Liu on 16/8/23.
//  Copyright © 2016年 Kravis Liu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UIScrollViewDelegate
{
    @IBAction func goBackToIntroView(segue: UIStoryboardSegue) {
        if let viewControllerIdentifier = segue.sourceViewController.restorationIdentifier {
            switch viewControllerIdentifier {
            case "RegisterView":
                print("Hello, I am back from RegisterView.")
            case "SignInView":
                print("Hello, I am back from SignInView.")
            default:
                break
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置代理
        scrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //显示 pageControl
        let pageWidth = scrollView.contentSize.width / 4
        let offsetX = scrollView.contentOffset.x
        let currentPage = Int(offsetX/pageWidth)
        pageControl.currentPage = currentPage
    }
}