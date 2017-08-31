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
import Alamofire
import RxAlamofire

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//      1. sample()
        textField
            .rx
            .text
            .sample(button.rx.tap)
            .subscribe(onNext: { print($0 ?? "nil text") })
            .addDisposableTo(rx.disposeBag)
    
//      2. flatMap()
//        textField
//            .rx
//            .text
//            .sample(button.rx.tap)
//            .flatMap { text -> Observable<String> in
//                guard let text = text, let url = URL(string: text) else {
//                    return Observable.empty()
//                }
//
//                return SessionManager.default
//                    .rx
//                    .data(.get, url)
//                    .map { data in
//                        return String(data: data, encoding: String.Encoding.utf8) ?? "Encoding error"
//                    }
//            }
//            .do(onNext: { print($0) })
//            .bind(to: label.rx.text)
//            .addDisposableTo(rx.disposeBag)

//      3. Error handling
//        textField
//            .rx
//            .text
//            .sample(button.rx.tap)
//            .flatMap { text -> Observable<String> in
//                guard let text = text, let url = URL(string: text) else {
//                    return Observable.empty()
//                }
//
//                return SessionManager.default
//                    .rx
//                    .data(.get, url)
//                    .map { data in
//                        return String(data: data, encoding: String.Encoding.utf8) ?? "Encoding error"
//                    }.catchErrorJustReturn("Network error")
//            }
//            .do(onNext: { print($0) })
//            .bind(to: label.rx.text)
//            .addDisposableTo(rx.disposeBag)


//      4. Combinging observables
        let performNetworkingRequest = Observable.merge([
            button.rx.tap.map { Void() },
            textField.rx.controlEvent(.editingDidEndOnExit).map { Void() }
        ])
        textField
            .rx
            .text
            .sample(performNetworkingRequest)
            .flatMap { text -> Observable<String> in
                guard let text = text, let url = URL(string: text) else {
                    return Observable.empty()
                }

                return SessionManager.default
                    .rx
                    .data(.get, url)
                    .map { data in
                        return String(data: data, encoding: String.Encoding.utf8) ?? "Encoding error"
                    }.catchErrorJustReturn("Network error")
            }
            .do(onNext: { print($0) })
            .bind(to: label.rx.text)
            .addDisposableTo(rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

