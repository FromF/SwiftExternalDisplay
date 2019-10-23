//
//  ViewController.swift
//  SwiftExternalDisplay
//
//  Created by 藤　治仁 on 2019/10/20.
//  Copyright © 2019 FromF.github.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    ///外部ディスプレイに表示するExternalDisplayViewControllerクラスのインスタンスを保持するための変数を用意する
    private var externalDisplayViewController:ExternalDisplayViewController?
    
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
        
        center.addObserver(self, selector: #selector(externalScreenWillConnect(notification:)), name: UIScene.willConnectNotification, object: nil)

        center.addObserver(self, selector: #selector(externalScreenDidDisconnect(notification:)), name: UIScene.didDisconnectNotification, object: nil)

    }
    
    /// 外部ディスプレイを接続されたときに処理する
    /// - Parameter notification:接続されたUIWindowSceneインスタンス
    @objc func externalScreenWillConnect(notification: NSNotification) {
        guard let windowScene = notification.object as? UIWindowScene else { return }
        guard externalWindow == nil else { return }
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ExternalDisplayViewController") as? ExternalDisplayViewController else { return }

        externalWindow = UIWindow(frame: windowScene.screen.bounds)
        
        guard let _externalWindow = externalWindow else { return }
        _externalWindow.rootViewController = viewController
        _externalWindow.windowScene = windowScene
        _externalWindow.isHidden = false
        
        //外部ディスプレイのViewControllerをあとで操作できるようにインスタンスを保持する
        externalDisplayViewController = viewController
    }
    
    /// 外部ディスプレイを切断されたときに処理する
    /// - Parameter notification: 切断されたUIWindowSceneインスタンス
    @objc func externalScreenDidDisconnect(notification: NSNotification) {
        guard let windowScene = notification.object as? UIWindowScene else { return }
        guard let _externalWindow = externalWindow else { return }
        guard let _externalWindowScene = _externalWindow.windowScene else { return }
        
        //切断通知されたscreenと現在表示中のscreenが同じかチェックする
        if windowScene == _externalWindowScene {
            _externalWindow.isHidden = true
            externalWindow = nil
        }
    }

    
}
