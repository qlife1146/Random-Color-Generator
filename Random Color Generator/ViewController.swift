//
//  ViewController.swift
//  Random Color Generator
//
//  Created by Luca Park on 5/7/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var colorView: UIView!
    @IBOutlet var colorValueLabel: UILabel!
    @IBOutlet var generateButton: UIButton!
    @IBOutlet var resetButton: UIButton!

    var r = CGFloat.random(in: 0...1)
    var g = CGFloat.random(in: 0...1)
    var b = CGFloat.random(in: 0...1)

    @IBAction func generateBgColor(_ sender: UIButton) {
        randomColor()
        changeColor()
    }

    @IBAction func resetColor(_ sender: UIButton) {
        colorView.backgroundColor = UIColor.white
        colorValueLabel.text = "R: 255, G: 255, B: 255"
        colorValueLabel.textColor = .black
    }

    func randomColor() {
        r = CGFloat.random(in: 0...1)
        g = CGFloat.random(in: 0...1)
        b = CGFloat.random(in: 0...1)
//        print("random: \(round(r*255)), \(round(g*255)), \(round(b*255))")
    }

    func changeColor() {
        // 백그라운드 컬러 변경
        colorView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        colorValueLabel.text = "R: \(floatToInt(r)), G: \(floatToInt(g)), B: \(floatToInt(b))"

        // 백그라운드 컬러의 명조에 맞춰 텍스트 컬러 흑백 전환
        let backColorLuminance = relativeLuminance(r: r, g: g, b: b)
        let whiteLuminance: CGFloat = relativeLuminance(r: 1, g: 1, b: 1)
        let blackLuminance: CGFloat = relativeLuminance(r: 0, g: 0, b: 0)
        let contrastRateWhite = contrastRatio(
            backColorLuminance,
            whiteLuminance
        )
        let contrastRateBlack = contrastRatio(
            backColorLuminance,
            blackLuminance
        )

        if contrastRateWhite >= 4.5 {
            colorValueLabel.textColor = .white
        } else if contrastRateBlack >= 4.5 {
            colorValueLabel.textColor = .black
        } else if contrastRateWhite > contrastRateBlack {
            colorValueLabel.textColor = .white
        } else {
            colorValueLabel.textColor = .black
        }
    }

    func adjusted(_ component: CGFloat) -> CGFloat {
        // 상대 명도 계산
        return component <= 0.03928 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
    }

    func relativeLuminance(r: CGFloat, g: CGFloat, b: CGFloat) -> CGFloat {
        // 감마 보정
        // L=0.2126×R+0.7152×G+0.0722×B
        let r = adjusted(r)
        let g = adjusted(g)
        let b = adjusted(b)
        return 0.2126*r + 0.7152*g + 0.0722*b
    }

    func contrastRatio(_ L1: CGFloat, _ L2: CGFloat) -> CGFloat {
        // 명도비
        return (max(L1, L2) + 0.05) / (min(L1, L2) + 0.05)
    }

    func floatToInt(_ value: CGFloat) -> Int {
        return Int(round(value*255))
    }

    func debug() {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        print("\(round(r*255)), \(round(g*255)), \(round(b*255))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
