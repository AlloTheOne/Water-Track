//
//  ContentView.swift
//  WaterTrack
//
//  Created by sumayah on 16/06/1444 AH.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = CoreDataBootcamp()
    @State var progress : CGFloat = 0.0
    @State var startAnimation: CGFloat = 0
    var body: some View {
        VStack{
            
            HStack{
                Button(action: {
                    
                    
                },label: {
                    Text("Re Calculate")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("Blue")
                            .cornerRadius(10)
                            .shadow(radius: 10))
                    
                    
                }).padding()
                Spacer()
                  
                Button(action: {
                    
                    
                },label: {
                    Text("Set Interval")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color("Blue")
                            .cornerRadius(10)
                            .shadow(radius: 10))
                    
                } ).padding()
            }
            VStack( spacing: 10){
                
                Text("Your Daily Water Intake :")
                ForEach(vm.savedEntities) { entity in
                    Text("\((String(format: "%.2f", entity.waterIntake ))) Liters")
                    Text("≈")
                    Text("\(Int((entity.waterIntake * 3.51951).rounded(.up))) Cups")
                
            }
                
            }
                     
            .padding(.bottom, 150.0)
            
            GeometryReader{proxy in
                let size = proxy.size
                
                ZStack (alignment: .center){
                    
                    Image(systemName: "drop.fill")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                    
                    //Streching in x Axis
                        .scaleEffect(x: 1.1,y: 1)
                        .offset(y: -1)
                    
                    //wave form shape
                    WaterWave(progress: progress, waveHeight: 0.1, offset: startAnimation)
                        .fill(Color("Blue"))
                    //Water Drops
                        .overlay(content: {
                            ZStack{
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 15, height:15)
                                    .offset(x: -20)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 15, height:15)
                                    .offset(x: 40,y: 30)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 25, height:25)
                                    .offset(x: -30,y:80)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 25, height:25)
                                    .offset(x: 50,y:70)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 10, height:10)
                                    .offset(x: 40,y:100)
                                Circle()
                                    .fill(.white.opacity(0.1))
                                    .frame(width: 25, height:25)
                                    .offset(x: -40,y:50)
                            }
                            
                        })
                    
                    // Masking into drop shape
                        .mask {
                            Image(systemName: "drop.fill")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                        }
                    //Add Button
                    
                        .overlay(alignment: .bottomTrailing){
                            Button{
                                if progress < 0.99  {

                                        progress += 0.1

                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 40, weight: .black))
                                    .foregroundColor(Color("Blue"))
                                    .shadow(radius: 2)
                                    .padding(8) 
                                    .background(.white,in: Circle())
                                
                            }
                        }
                        .overlay(alignment: .bottomLeading){
                            Button{
                                if progress > 0.09 { 
                                    progress -= 0.1
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 40, weight: .black))
                                    .foregroundColor(Color("Blue"))
                                    .shadow(radius: 2)
                                    .padding(20)
                                    .background(.white,in: Circle())
                                
                            }
                     
                        }
                    
                                    
                }
            
                //                .frame(width: size.width, height: size.height, alignment: .center)
                
                .onAppear {
                    // Loading Animation
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses:false)){
                        // If you set value less than the rect width t will not finish completely
                        startAnimation = size.width
                    }
                }
            }
            .frame(height: 350)
            //Slider(value: $progress)
            Text("\(Int((progress * 100).rounded()))%").bold()
                .padding()
            
        }
        //.padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("BG"))
        
        
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WaterWave: Shape {
    
    var progress: CGFloat
    // wave height
    var waveHeight: CGFloat
    // intial animation start
    var offset : CGFloat
    
    // enabling animation
    var animatableData: CGFloat {
        get {offset}
        set {offset = newValue}
    }
    
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: .zero)
            let progressHeight: CGFloat = (1 - progress) * rect.height
            let height = waveHeight * rect.height
            
            for value in stride(from: 0, to: rect.width, by: 2){
                let x: CGFloat = value
                let sine: CGFloat = sin(Angle(degrees: value + offset).radians)
                let y: CGFloat = progressHeight + (height * sine)
                path.addLine(to: CGPoint(x: x, y:y))
                
            }
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
        }
    }
}
