//
//  UnderLineNavBar.swift
//  Moa
//
//  Created by won heo on 2021/11/17.
//

import UIKit

protocol UnderLineNavBar: UIViewController {}

extension UnderLineNavBar {
    func addUnderLineOnNavBar(bottomConstatnt constant: CGFloat = 14) {
        let lineView = makeLineView()
        view.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: constant
            )
        ])
    }
    
    private func makeLineView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xf2f2f2)
        return view
    }
}
