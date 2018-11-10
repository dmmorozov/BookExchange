//
//  MainViewController.swift
//  BookExchange
//
//  Created by Dmitrii Morozov on 09/11/2018.
//  Copyright © 2018 Hackaton2018. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.2374315262, green: 0.2745304406, blue: 0.3262515962, alpha: 1)
        UITabBar.appearance().tintColor = .white
    }
}
