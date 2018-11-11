//
//  BookShelveViewController.swift
//  BookExchange
//
//  Created by Dmitrii Morozov on 09/11/2018.
//  Copyright © 2018 Hackaton2018. All rights reserved.
//

import UIKit

class BookShelveViewController: UIViewController {
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    @IBOutlet var addButton: UIButton!
    @IBOutlet var plusImage: UIImageView!
    
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GLTableCollectionViewController")
        add(controller, to: containerView)
        view.addSubview(addButton)
        view.addSubview(plusImage)
    }
}

