//
//  ViewController.swift
//  QuoteOfTheDay
//
//  Created by Ernest Chechelski on 28/10/2020.
//

import UIKit
import FirebaseRemoteConfig

@inline(__always) func with<T>(_ target: T, block: (T) -> Void) -> T {
    block(target)
    return target
}

final class ViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
        mainLabel.isUserInteractionEnabled = true
        mainLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(refresh)))
    }

    @objc private func refresh() {
        let remoteConfig = with(RemoteConfig.remoteConfig()) {
            $0.configSettings = with(RemoteConfigSettings()) {
                $0.minimumFetchInterval = 0
            }
        }
        remoteConfig.fetchAndActivate { _, _ in
            DispatchQueue.main.async { [weak self] in
                self?.mainLabel.text = remoteConfig["text"].stringValue
            }
        }
    }
}

