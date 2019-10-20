//
//  ViewController.swift
//  SwiftExternalDisplay
//
//  Created by 藤　治仁 on 2019/10/20.
//  Copyright © 2019 FromF.github.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    ///外部ディスプレイに表示するViewControllerクラスのExternalDisplayViewController()のインスタンスを生成する
    private let externalDisplayViewController = ExternalDisplayViewController()
    
    ///外部ディスプレイに表示するUIWindowを保持する変数
    private var externalWindow : UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNotification()
    }

    // MARK: - Notification
    /// 外部ディスプレイの接続と切断の通知を受け取れるようにする
    private func setupNotification() {
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(externalScreenDidConnect(notification:)), name: UIScreen.didConnectNotification, object: nil)

        center.addObserver(self, selector: #selector(externalScreenDidDisconnect(notification:)), name: UIScreen.didDisconnectNotification, object: nil)

    }
    
    /// 外部ディスプレイを接続されたときに処理する
    /// - Parameter notification:接続されたUIScreenインスタンス
    @objc func externalScreenDidConnect(notification: NSNotification) {
        guard let screen = notification.object as? UIScreen else { return }
        guard externalWindow == nil else { return }

        externalWindow = UIWindow(frame: screen.bounds)
        
        guard let _externalWindow = externalWindow else { return }
        _externalWindow.rootViewController = externalDisplayViewController
        _externalWindow.screen = screen
        _externalWindow.isHidden = false
    }
    
    /// 外部ディスプレイを切断されたときに処理する
    /// - Parameter notification: 切断されたUIScreenインスタンス
    @objc func externalScreenDidDisconnect(notification: NSNotification) {
        guard let screen = notification.object as? UIScreen else { return }
        guard let _externalWindow = externalWindow else { return }
        
        //切断通知されたscreenと現在表示中のscreenが同じかチェックする
        if screen == _externalWindow.screen {
            _externalWindow.isHidden = true
            externalWindow = nil
        }
    }

    
}

//[参考サイト]
//https://www.swiftjectivec.com/supporting-external-displays/
//http://www.spazstik-software.com/blog/article/how-to-display-custom-content-on-a-external-screen-from-a-ios-device
//https://stackoverflow.com/questions/56704389/overscancompensation-on-external-screen-on-ios-13-beta
