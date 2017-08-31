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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        textField
            .rx
            .text
            .subscribe(onNext: { print($0 ?? "nil text") })
            .addDisposableTo(self.rx.disposeBag)

        textField
            .rx
            .text
            .bind(to: label.rx.text)
            .addDisposableTo(self.rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

