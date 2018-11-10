//
//  UIViewController+.swift
//  BookExchange
//
//  Created by Dmitrii Morozov on 09/11/2018.
//  Copyright © 2018 Hackaton2018. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

extension UIViewController {
    func goToMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        present(controller, animated: true, completion: nil)
    }
    
    func showLoadingView() {
        self.view.makeToastActivity(.center)
    }
    
    func hideLoadingView() {
        self.view.hideToast()
    }
    
    func add(_ child: UIViewController, to: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.view.frame = to.frame
        child.didMove(toParent: self)
    }
    
    /// It removes the child view controller from the parent.
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
