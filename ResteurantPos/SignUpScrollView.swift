//
//  SignUpScrollView.swift
//  ResteurantPos
//
//  Created by Lin Wei on 3/14/16.
//  Copyright © 2016 Lin Wei. All rights reserved.
//

import UIKit

protocol SignUpScrollViewDelegate {
    
    func dissmiss()
}

class SignUpScrollView: UIScrollView {

    var delegateB:SignUpScrollViewDelegate?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        delegateB?.dissmiss()
        
    }
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
