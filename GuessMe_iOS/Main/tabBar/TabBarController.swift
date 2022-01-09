//
//  TabBarController.swift
//  GuessMe_iOS
//
//  Created by 박희지 on 2022/01/09.
//

import UIKit
import RxSwift

class TabBarController: UITabBarController {
    private let disposeBag = DisposeBag()
    
    static func instance() -> TabBarController {
        return TabBarController(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTabBarController()
        if #available(iOS 13, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            self.tabBar.standardAppearance = appearance
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case tabBarTag.main.rawValue:
            self.tabBar.barTintColor = .lightGray
            if #available(iOS 15, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .lightGray
                self.tabBar.standardAppearance = appearance
            }
        case tabBarTag.mypage.rawValue:
            self.tabBar.barTintColor = .lightGray
            if #available(iOS 15, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .lightGray
                self.tabBar.standardAppearance = appearance
            }
        default:
            break
        }
    }
    
    private func setUpTabBarController() {
        self.setViewControllers([MainViewController.instance(),
                                 MyPageTableViewController.instance()], animated: true)
        self.tabBar.tintColor = .accentColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.clipsToBounds = true
        self.tabBar.barTintColor = .mainColor
        self.tabBar.barStyle = .default
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navigationVC = viewController as? UINavigationController {
            if navigationVC.topViewController is MainViewController {
                let mainVC = MainViewController.instance()
                
                self.present(mainVC, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
}
