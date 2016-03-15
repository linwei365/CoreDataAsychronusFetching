//
//  SignUpUIView.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/14/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit

protocol SignUpUiViewDelegate {
    
    func dismisskeyboard()
}


class SignUpUIView: UIView {

    var delegate:SignUpUiViewDelegate?
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        delegate?.dismisskeyboard()
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
