//
//  BannerAd.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/17.
//

import SwiftUI
import UIKit // こちらも必要
import GoogleMobileAds // 忘れずに

struct AdMobBannerView: UIViewRepresentable {
    
    static let adsBannerSize: CGSize = CGSize(width: 320, height: 50)
        
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner) // インスタンスを生成
        // 諸々の設定をしていく
        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 自身の広告IDに置き換える
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner // 最終的にインスタンスを返す
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
      // 特にないのでメソッドだけ用意
    }
}
