//
//  ActionLabelView.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 5.02.2024.
//

import UIKit

protocol ActionLabelViewDelegate:AnyObject{
   func  actionLabelViewDidTapButton()
}

struct ActionLabelViewViewModel{
    let text:String
    let actionTitle:String
}


class ActionLabelView: UIView {
    
    weak var delegate:ActionLabelViewDelegate?
    
    private let label:UILabel={
        let label=UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15,weight: .medium)
        return label
    }()
    
    private let button:UIButton={
       let button=UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        isHidden = true
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame=CGRect(x: 0, y: height-55, width: width, height: 40)
        label.frame=CGRect(x: 0, y: 0, width: width, height: height-45)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapButton(){
        self.delegate?.actionLabelViewDidTapButton()
    }
    func configure(with model:ActionLabelViewViewModel){
        label.text=model.text
        button.setTitle(model.actionTitle, for: .normal)
    }
        
}
