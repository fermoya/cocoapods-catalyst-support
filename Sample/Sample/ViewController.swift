//
//  ViewController.swift
//  Sample
//
//  Created by Fernando Moya de Rivas on 23/1/21.
//

import UIKit

#if canImport(AdColony)
import AdColony
#endif

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        #if canImport(AdColony)
        print("Imported")
        #else
        print("Not imported")
        #endif
    }

}
