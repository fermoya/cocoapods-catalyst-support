//
//  ViewController.swift
//  Sample
//
//  Created by Fernando Moya de Rivas on 23/1/21.
//

import UIKit

#if canImport(Firebase)
import Firebase
#endif

#if canImport(AppCenter)
import AppCenter
#endif

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

class Test {
    func doSth() {
        #if canImport(AppCenter)
        print("AppCenter can be imported")
        #endif
        #if canImport(Firebase)
        print("Firebase can be imported")
        #endif
    }
}
