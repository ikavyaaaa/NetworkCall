//
//  SceneDelegate.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 26/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        kSceneDelegate = self
        guard let _ = (scene as? UIWindowScene) else { return }
        if let windowScene = scene as? UIWindowScene{
            let window = UIWindow(windowScene: windowScene)
            let rootViewController = Main.instantiate(fromAppStoryboard: .main)
            window.rootViewController = rootViewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}


extension SceneDelegate {
    
    func switchToView() {
        if UserDefaults.standard.bool(forKey: UserDefaultConstants.rememberMe) == true {
            setHome()
        } else {
            setLogin()
        }
    }
    
    func setHome() {
        UIApplication.shared.keyWindow?.rootViewController = ViewController()
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    func setLogin() {
        let loginVC = LoginVC.instantiate(fromAppStoryboard: .main)
        UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }

}
