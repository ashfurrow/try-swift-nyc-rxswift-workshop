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

        textField
            .rx
            .text
            .filterNil()
            .sample(button.rx.tap)
            .subscribe(onNext: { print($0) })
            .addDisposableTo(rx.disposeBag)

        let performNetworkingRequest = Observable.merge([
            button.rx.tap.eraseType(),
            textField.rx.returnKey
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
            .log() // 1.
            .bind(to: label.rx.text)
            .addDisposableTo(rx.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// 1. Adding observable operators.
extension ObservableType where E: CustomStringConvertible {
    func log() -> Observable<E> {
        return self.do(onNext: { string in
            print(string)
        }, onError: { error in
            print("error!")
            print(error)
        }, onCompleted: { 
            print("completed")
        })
    }
}

extension ObservableType {
    func eraseType() -> Observable<Void> {
        return self.map { _ in return Void() }
    }
}

// Fun things with optionals

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}
extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.Wrapped> {
        return self.flatMap { element -> Observable<E.Wrapped> in
            guard let value = element.value else { return Observable.empty() }
            return Observable.just(value)
        }
    }
}

// 2. Extending types to add Rx extensions.
extension Reactive where Base: UITextField {
    var returnKey: Observable<Void> {
        return self.controlEvent(.editingDidEndOnExit).eraseType()
    }
}
