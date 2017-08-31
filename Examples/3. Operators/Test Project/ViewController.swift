//
//  ViewController.swift
//  Test Project
//
//  Created by Ash Furrow on 2017-08-31.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        textField
            .rx
            .text
            .filter { text in
                guard let text = text else { return false }
                return text.characters.count > 5
            }
            .subscribe(onNext: { print($0 ?? "nil text") })
            .addDisposableTo(self.rx.disposeBag)

//      1. Basic mapping
//        button
//            .rx
//            .tap
//            .map { _ in Date().description }
//            .bind(to: label.rx.text)
//            .addDisposableTo(rx.disposeBag)

//      2. Adding startWith()
//        button
//            .rx
//            .tap
//            .map { _ in Date().description }
//            .startWith(Date().description)
//            .bind(to: label.rx.text)
//            .addDisposableTo(rx.disposeBag)

//      3. Being clever
        button
            .rx
            .tap
            .map { _ in Date() }
            .startWith(Date())
            .map { $0.description }
            .bind(to: label.rx.text)
            .addDisposableTo(rx.disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

