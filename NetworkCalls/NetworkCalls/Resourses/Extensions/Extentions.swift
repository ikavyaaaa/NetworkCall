//
//  Extentions.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 02/12/24.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func setStatusBarForDarkBackground(_ dark: Bool) {
        if dark {
            var preferredStatusBarStyle: UIStatusBarStyle {
                return .darkContent
            }
        } else {
            var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
            }
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    var navigationBarHeight: CGFloat {
        let statusBarSize = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame
        return (self.navigationController?.navigationBar.frame.size.height)! + Swift.min(statusBarSize?.width ?? 0, statusBarSize?.height ?? 0)
    }
    
    
    func add(_ child: UIViewController, containerView: UIView) {
        addChild(child)
        //child.tabBarController?.tabBar.isHidden = true
        containerView.addSubview(child.view)
        child.view.frame = containerView.bounds
        child.didMove(toParent: self)
    }
    
    func remove(containerView: UIView) {
        guard parent != nil else { return }
        willMove(toParent: nil)
        self.view.removeFromSuperview()
        removeFromParent()
    }
    
    func pushTo<T: UIViewController>(_ viewController : T) {
        viewController.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func push<T>(_ viewController: T) where T : UIViewController {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 200)) {
            viewController.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    func presentTo<T: UIViewController>(_ viewController : T) {
        viewController.tabBarController?.tabBar.isHidden = true
        self.present(viewController, animated: false, completion: nil)
    }
    
    func popViewController() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    func pushToViewController<T: UIViewController>(sbName: String, vcName: String) -> T {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcName) as! T
        return vc
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
