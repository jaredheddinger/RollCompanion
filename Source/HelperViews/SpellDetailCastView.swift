//
//  SpellDetailView.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 3/26/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SpellDetailCastView : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var textScroll: UIScrollView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var spell : Spell?
    var level : Int?
    var character : Character1?
    var delegate: SpellDetailCastViewDelegate?
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        titleLabel.text = spell?.name

        textLabel.text = spell?.text
        textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel.numberOfLines = 100
        
        levelLabel.text = spell?.level == 0 ? "Cantrip" : spell?.level.description ?? "-1" + "lv."
        spell?.upcast ?? false ? levelLabel.text?.append("+") : nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapCastButton(_ sender: Any) {
        let presentingTabBar = self.presentingViewController as! UITabBarController
        let presentingVC = presentingTabBar.viewControllers?[2] as! CharacterDetailAvailableSpellsView
        self.dismiss(animated: true, completion: {
            self.character!.toSpellSlots?.decrementSlots(slot: self.level!)
            presentingVC.availableSpellsTable.reloadSections(IndexSet.init(integer: self.level!), with: .fade)
        })
    }
    
}

protocol SpellDetailCastViewDelegate: class {
    func cancelButtonTapped()
}

extension SpellDetailCastView : SpellDetailCastViewDelegate {
    func cancelButtonTapped() {
        print("cancelButtonTapped")
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}
