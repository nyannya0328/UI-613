//
//  Extension.swift
//  UI-613
//
//  Created by nyannyan0328 on 2022/07/16.
//

import SwiftUI

extension View{
    
    func offsetX(competion : @escaping(CGFloat) -> ())->some View{
        
        self
            .overlay {
                
                GeometryReader{proxy in
                    
                    let minX = proxy.frame(in: .global).minX
                    
                    Color.clear
                    
                        .preference(key :offsetKey.self ,value: minX)
                        .onPreferenceChange(offsetKey.self) { value in
                            
                            competion(value)
                            
                            
                        }
                }
            }
        
    }
    
    
}

struct offsetKey : PreferenceKey{
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
