//
//  Home.swift
//  UI-613
//
//  Created by nyannyan0328 on 2022/07/16.
//

import SwiftUI

struct Home: View {
    @State var offset : CGFloat = 0
    @State var isTapped : Bool = false
    @State var currentSlider : Tab = sampleTabs.first!
    
    @StateObject var  model : IndciatorOffset = .init()
    var body: some View {
        GeometryReader{proxy in
            
             let screenSize = proxy.size
            
            
            ZStack(alignment:.top){
                
                TabView(selection: $currentSlider) {
                    
                    
                    ForEach(sampleTabs){tab in
                        
                        GeometryReader{proxy in
                            
                             let size = proxy.size
                            
                            Image(tab.sampleImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width,height: size.height)
                                .clipped()
                        }
                       
                        .ignoresSafeArea()
                        .offsetX { value in
                            
                            if currentSlider == tab && !isTapped{
                                
                                offset = value - (screenSize.width * CGFloat(indexOF(tab: tab)))
                                
                                
                            }
                            if value == 0 && isTapped{
                                
                                isTapped = false
                            }
                            
                            if isTapped && model.isInteracting{
                                
                                isTapped = false
                            }
                            
                        }
                        .tag(tab)
                        
                    }
                    
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear{model.addGestrue()}
                .onDisappear{model.removeGesture()}
                
                
                DaynamicHeaderView(size: screenSize)
                
            
                
                
            }
            .frame(width: screenSize.width,height: screenSize.height)
        }
    }
    
    
    @ViewBuilder
    func DaynamicHeaderView(size : CGSize)->some View{
        VStack(alignment:.leading){
            
            Text("Dynamic Tabs")
                .font(.title.weight(.black))
                .foregroundColor(.white)
           
            
            
            HStack(spacing:0){
                
                ForEach(sampleTabs){tab in
                    
                    Text(tab.tabName)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity,alignment: .center)
                        .padding(.vertical,6)
                       
                   
                }
            }
            .overlay(alignment:.leading) {
                
                Capsule()
                    .fill(.white)
                    .overlay(alignment:.leading) {
                        
                        GeometryReader{_ in
                            
                            HStack(spacing:0){
                                
                                
                                ForEach(sampleTabs){tab in
                                    
                                    Text(tab.tabName)
                                        .fontWeight(.bold)
                                        .frame(maxWidth: .infinity,alignment: .center)
                                        .padding(.vertical,6)
                                        .foregroundColor(.black)
                                        .contentShape(Capsule())
                                        .onTapGesture {
                                            withAnimation(.easeInOut){
                                                
                                                isTapped = true
                                                
                                            currentSlider = tab
                                                
                                                offset = -(size.width) * CGFloat(indexOF(tab: tab))
                                                
                                            }
                                        }


                                }
                                
                             
                                
                                
                                
                            }
                            .offset(x:-tabOffset(size: size, padding: 30))
                            
                        }
                        .frame(width : size.width - 30)
                        
                    }
                    .frame(width:(size.width - 30) / CGFloat(sampleTabs.count))
                    .mask {
                        Capsule()
                    }
                    .offset(x:tabOffset(size: size, padding: 30))
                
            }
           
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(15)
        .background{
        
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
        
        
    }
    
    func tabOffset(size : CGSize,padding : CGFloat)->CGFloat{
        
        return (-offset / size.width) * ((size.width - padding) / CGFloat(sampleTabs.count))
        
    }
    
    func indexOF(tab : Tab) -> Int{
        
        
        let index = sampleTabs.firstIndex { CAB in
            CAB == tab
        } ?? 0
        
        return index
  
    }
    

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class IndciatorOffset : NSObject,ObservableObject,UIGestureRecognizerDelegate{
    
    @Published var isInteracting : Bool = false
    @Published var isGestureAdded : Bool = false
    
    
    func addGestrue(){
        
        if !isGestureAdded{
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(OnChange(gesture: )))
            
            gesture.name = "UNIVERSAL"
            gesture.delegate = self
            
            guard let widowScane = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return}
            
            guard let window = widowScane.windows.last?.rootViewController else{return}
            
            window.view.addGestureRecognizer(gesture)
            
            isGestureAdded = true
            
        }
        
        
    }
    func removeGesture(){
        
        guard let widowScane = UIApplication.shared.connectedScenes.first as? UIWindowScene else{return}
        
        guard let window = widowScane.windows.last?.rootViewController else{return}
        
        window.view.gestureRecognizers?.removeAll(where: { gesture in
            return gesture.name == "UNIVERSAL"
            
            
            
        })
        isGestureAdded = false
        
    }
    @objc
    func OnChange(gesture : UIPanGestureRecognizer){
        
        isInteracting = (gesture.state == .changed)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
