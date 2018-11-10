//
//  ViewController.swift
//  BookExchange
//
//  Created by Dmitrii Morozov on 09/11/2018.
//  Copyright © 2018 Hackaton2018. All rights reserved.
//

import UIKit
import VK_ios_sdk
import Alamofire
import Toast_Swift

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    @IBOutlet var loginButton: UIButton!
    var vkSdk: VKSdk!
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.error != nil {
            let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при авторизации", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in }))
            self.present(alert, animated: true, completion: nil);
            return
        }
        if let token = result.token.accessToken {
            showLoadingView()
            BookService.sharedInstance.send(token: token) { serverToken in
                print(serverToken ?? "")
                if let token = serverToken, !token.isEmpty {
                    UserDefaults.standard.set(token, forKey: "token")
                }
                self.hideLoadingView()
                self.goToMainViewController()
            }
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при авторизации", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in }))
            self.present(alert, animated: true, completion: nil);
            return
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        VKSdk.authorize(["friends", "email"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vkSdk = appDelegate.vkSdk
        vkSdk!.register(self)
        vkSdk!.uiDelegate = self
    }
}

struct Book {
    let imageUrlString:String
    let title:String
    let author: String
}

func testMyBooks() -> [Book] {
    let book1 = Book(imageUrlString: "http://yandex.ru", title: "Морской волк", author: "Джек Лондон")
    let book2 = Book(imageUrlString: "http://google.ru", title: "Гарри Поттер и философский камень", author: "Джоан Роулинг")
    let book3 = Book(imageUrlString: "http://google.ru", title: "Война миров", author: "Герберт Уэллс")
    let book4 = Book(imageUrlString: "http://google.ru", title: "Июнь", author: "Дмитрий Быков")
    
    return [book1, book2, book3, book4]
}

func testFreeBooks() -> [Book] {
    let book1 = Book(imageUrlString: "http://yandex.ru", title: "Острые предметы", author: "Гиллиан Флинн")
    let book2 = Book(imageUrlString: "http://google.ru", title: "Ленин", author: "Лев Данилкин")
    let book3 = Book(imageUrlString: "http://google.ru", title: "Тайный год", author: "Михаил Гиголашвили")
    let book4 = Book(imageUrlString: "http://google.ru", title: "Дом, в котором", author: "Мариам Петросян")
    
    return [book1, book2, book3, book4]
}

func testNowReadingBooks() -> [Book] {
    let book1 = Book(imageUrlString: "http://yandex.ru", title: "Убийство в восточном экспрессе", author: "Агата Кристи")
    
    return [book1]
}

