//
//  MetadataBounds.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 09-07-18.
//

import Foundation
class MetadataBounds:Equatable{
    var left:Double
    var bottom:Double
    var right:Double
    var top:Double
    
    init(serialized:String) {
        let split = serialized.split(separator: ",")
        let left = Double(split[0])
        let bottom = Double(split[1])
        let right = Double(split[2])
        let top = Double(split[3])
        self.left = left!.isLess(than: -100) ? -100 : left!
        self.bottom = bottom!.isLess(than: -85) ? -85 : bottom!
        self.right = !right!.isLess(than: 100) ? 100 : right!
        self.top = !top!.isLess(than: 85) ? 85 : top!
    }
    
    init(left:Double,bottom:Double,right:Double,top:Double) {
        self.left = left.isLess(than: -100) ? -100 : left
        self.bottom = bottom.isLess(than: -85) ? -85 : bottom
        self.right = !right.isLess(than: 100) ? 100 : right
        self.top = !top.isLess(than: 85) ? 85 : top
    }
    
    func toString()->String{
        return "\(left),\(bottom),\(right),\(top)"
    }
    
    static func == (lhs: MetadataBounds, rhs:MetadataBounds)->Bool{
        return lhs.toString()==rhs.toString()
    }
}
