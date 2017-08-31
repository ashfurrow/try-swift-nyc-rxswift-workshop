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

//    var subscription: Disposable?
//    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//      1. Basic
//        textField
//            .rx
//            .text
//            .subscribe(onNext: { print($0 ?? "nil text") })

//      2. With subscription disposal.
//        subscription = textField
//            .rx
//            .text
//            .subscribe(onNext: { print($0 ?? "nil text") })


//      3. With a dispose bag
//        textField
//            .rx
//            .text
//            .subscribe(onNext: { print($0 ?? "nil text") })
//            .addDisposableTo(disposeBag)

//     42. With a dispose bag from NSObject+Rx
        textField
            .rx
            .text
            .subscribe(onNext: { print($0 ?? "nil text") })
            .addDisposableTo(self.rx.disposeBag)
    }

//    deinit {
//        subscription?.dispose()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

