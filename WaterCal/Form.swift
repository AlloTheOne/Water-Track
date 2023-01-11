//
//  Form.swift
//  WaterCal
//
//  Created by Alaa Alabdullah on 11/01/2023.
//

import SwiftUI
import CoreData

class CoreDataBootcamp: ObservableObject {
    let container: NSPersistentContainer
     @Published var savedEntities: [WaterEntity] = []
    
    init() {
        container =  NSPersistentContainer(name: "WaterContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("error loading data \(error)")
            }
        }
        fetchWater()
    }
    func fetchWater() {
        let request = NSFetchRequest<WaterEntity>(entityName: "WaterEntity")
        
        do {
           savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("error fetching \(error)")
        }
    }
    func addItem(waterIn: Double) {
        withAnimation {
           resetAllCoreData()
            
            let newWater = WaterEntity(context: container.viewContext)
            newWater.waterIntake = waterIn
            
            saveItems()
        }
    }
    
    func resetAllCoreData() {
         // get all entities and loop over them
        
        for x in savedEntities {
            container.viewContext.delete(x)
        }
        saveItems()
    }
    
    func saveItems() {
       do {
           try container.viewContext.save()
           fetchWater()
       } catch {
           print("error saving")
       }
   }
}


struct Form: View {
    @StateObject var vm = CoreDataBootcamp()
    @State var wightIn: String = ""
    @State var activity = 20
    @State var weather = "cold"
    @State var showDrop: Bool = false
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                VStack(alignment: .trailing) {
                    HStack { Spacer() }
//                    Button {
//                    } label: {
//                        Text("Set Interval")
//                            .frame(width: 150)
//                            .frame(height: 55)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .padding(.top)
//                    }
                }
                .frame(height: 150)
                .padding(.trailing)
                .background(Color("Blue"))
                .clipShape(RoundedShape(corners: [.bottomRight]))
                .ignoresSafeArea()
                
//                VStack {
//                    HStack { Spacer() }
//                    Text(" ")
//                }
//                .frame(height: 90)
//                .padding(.trailing)
//                .background(Color.red)
//                .clipShape(RoundedShape(corners: [.topLeft]))
            
                Spacer()
                VStack {
                    LabeledContent {
                        VStack(alignment: .trailing) {
                            TextField("", text: $wightIn)
                                .padding(.leading, 35)
                                .foregroundColor(Color.white)
                                .frame(width: 90)
                                .frame(height: 35)
                                .background(Color("Blue"))
                                .cornerRadius(10)
                                .padding()
                            //                            .padding(.horizontal)
                                //.padding(.leading, 80)
                            
                        
                                
                        }
                    } label: {
                        Text("your weight in kg")
                            .padding(.leading, 30)
                    }
                    //.font(.headline)
                    .tint(Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color("lightShadow"), radius: 5, x: 0, y: 0.5)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    
                    LabeledContent {
                        Picker("Option Picker", selection: $activity) {
                            Text("20").tag(20)
                            Text("30").tag(30)
                            Text("40").tag(40)
                        }.pickerStyle(MenuPickerStyle())
                            .frame(width: 90)
                            .frame(height: 35)
                            .tint(Color.white)
                            .background(Color("Blue"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    } label: {
                        Text("Activity in minutes")
                            .padding(.leading, 40)
                    }
                    //.font(.headline)
                    .tint(Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color("lightShadow"), radius: 5, x: 0, y: 0.5)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    
//                    LabeledContent {
//                        Picker("Option Picker", selection: $weather) {
//                            Text("Cold").tag("Cold")
//                            Text("Warm").tag("Warm")
//                            Text("Hot").tag("Hot")
//                        }.pickerStyle(MenuPickerStyle())
//                            .frame(width: 90)
//                            .frame(height: 35)
//                            .tint(Color.white)
//                            .background(Color("Blue"))
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                    } label: {
//                        Text("Weather")
//                            .padding(.leading, 70)
//                    }
//                    .tint(Color.black)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 55)
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .shadow(color: Color("lightShadow"), radius: 5, x: 0, y: 0.5)
//                    .padding(.horizontal)
//                    .padding(.top)
//    
                    Spacer()
                    
//                    ForEach(vm.savedEntities) { entity in
//                       // Text(entity.waterIntake ?? 0.0)
//                    }
                    
                    Button {
                        guard !wightIn.isEmpty else { return }
                        let wieghtD = Double(wightIn)
                        Calculator(weightIn: wieghtD ?? 0.0, activityIn: activity, weatherIn: weather)
                        //vm.addItem(weightIn: wieghtD ?? 0.0, activityIn: activity, weatherIn: weather)
                        // here i should call calculator
                        wightIn = ""
                        showDrop.toggle()
                    } label: {
                        Text("Calculate")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color("Blue"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .fullScreenCover(isPresented: $showDrop) {
                        ContentView()
                    }
//                    Button {
//                        guard !wightIn.isEmpty else { return }
////                        vm.addItem(activityIn: wightIn)
//                        wightIn = ""
//                    } label: {
//                        Text("Reset")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 55)
//                            .background(Color("lightShadow"))
//                            .cornerRadius(10)
//                    }
//                    .padding(.horizontal)
                }
            }
        }
    }
    
    
    
    func Calculator(weightIn: Double, activityIn: Int, weatherIn: String) {
        // from kg to lb
        let weightOut = weightIn * 2.205
        // calculate with water only
        
        let waterIntakeAday = weightOut * 0.5
        // convert string to double
        let activityD = Double(activityIn)
        
        // calculator with activity
        
        let waterInActive = waterIntakeAday + ((activityD / 30) * 12 )
        
        // convert from oz to liter
        let liters = waterInActive / 33.814

        print(liters)
        
        // here i shoud call add item
        vm.addItem(waterIn: liters)
    }
}


struct Form_Previews: PreviewProvider {
    static var previews: some View {
        Form()
    }
}
