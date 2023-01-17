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
    @State var z: Int = 0
    @State var startAnimation: CGFloat = 0
    var cup: String?
    var body: some View {
        NavigationView {
            VStack{
                VStack {
                    HStack{
                        NavigationLink {
                            Form()
                        } label: {
                            Text("Re Calculate")
                                .foregroundColor(Color("Blue"))
                                .frame(width: 150)
                                .frame(height: 55)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.top ,30)
                        }
                        .padding()
                        Spacer()
                    }.frame(height: 150)
                        .padding(.trailing)
                        .background(Color("Blue"))
                        .clipShape(RoundedShape(corners: [.bottomRight]))
                        .ignoresSafeArea()
                }
                VStack( spacing: 10){
                    
                    Text("Your Daily Water Intake Is:")
                        .foregroundColor(Color.black)
                        .font(.headline)
                        .padding(.top)
                    ForEach(vm.savedEntities) { entity in
                        let cup = Int((entity.waterIntake * 3.51951).rounded(.up))
                        Text("\((String(format: "%.2f", entity.waterIntake ))) Liters")
                            .foregroundColor(Color.black)
                            .font(.headline)
                        Text("≈")
                            .foregroundColor(Color.black)
                            .font(.headline)
                        Text("\(cup) Cups")
                            .foregroundColor(Color.black)
                            .font(.headline)
                        
                    }
                    
                }
                
                .padding(.bottom, 100)
                VStack {
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
//                                        for x in vm.savedEntities {
//                                            let cup = Int((x.waterIntake * 3.51951).rounded(.up))
//                                            let cupCG = CGFloat(cup)
//                                            if progress * 10 < cupCG {
//
//
//
//
//                                                    progress += 0.1
//
//                                                print(Int((progress / cupCG * 1000)))
//                                                let z = Int((progress / cupCG * 1000))
//                                                //Text("\(Int((progress / cupCG * 1000)))")
////                                                Text("\(z)")
//                                            }
//                                        }
                                        addProgress()
                                        
                                    } label: {
                                        Image(systemName: "plus")
                                            .font(.system(size: 40, weight: .black))
                                            .foregroundColor(Color("Blue"))
                                            .shadow(radius: 2)
                                            .padding(8)
                                            .background(.white,in: Circle())
                                        
                                    }
                                }
                            //.padding([.top, .trailing])
                                .overlay(alignment: .bottomLeading){
                                    Button{
//                                        if progress > 0.09 {
//                                            progress -= 0.1
//                                          //  vm.addProgress(progress: progress)
//                                        }
                                        removeProgress()
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
                        
       
                        
                        .onAppear {
                            // Loading Animation
                            withAnimation(.linear(duration: 2).repeatForever(autoreverses:false)){
                                // If you set value less than the rect width t will not finish completely
                                startAnimation = size.width
                            }
                        }
                    }
                    .frame(height: 350)
                  // Text("\(cup)")
//                    ForEach(vm.savedEntities) { entity in
//                        let cup = Int((entity.waterIntake * 3.51951).rounded(.up))
////                        Text("\(cup) Cups")
////                        Text("\(Int((progress / cup * 100).rounded()))%").bold()
////                            .padding()
//                    }
//                    Text("\(Int((progress * 100).rounded()))%").bold()
//                        .padding()
//                    Text("\(Int((progress * 100).rounded()))%").bold()
                    Text("\(z) %")
                        .foregroundColor(Color.black)
                        .font(.headline)
                        .padding()
//                    addProgress()
//
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 40) 
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color("BG").gradient)
                    .ignoresSafeArea()
        }
        
        
    }
    
    func addProgress(){
        for x in vm.savedEntities {
            let cup = Int((x.waterIntake * 3.51951).rounded(.up))
            let cupCG = CGFloat(cup)
            if progress * 10 < cupCG {
                if z >= 85 && z <= 100 && progress > 0.5 {
                    z = 100
                } else{
  
                    progress += 0.1
                    z = Int((progress / cupCG * 1000))
                }

            }
        }
    }
    func removeProgress() {
        for x in vm.savedEntities {
            let cup = Int((x.waterIntake * 3.51951).rounded(.up))
            let cupCG = CGFloat(cup)
            if progress * 10 < cupCG {
                if  progress > 0.09 {
                    
               
  
                    progress -= 0.1
                    z = Int((progress / cupCG * 1000))
                }

            }
        }
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
