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
    @FocusState private var amountIsFocused: Bool
    
        
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @GestureState private var dragOffset = CGSize.zero
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                VStack(alignment: .trailing) {
                    HStack { Spacer() }
                 
                }
                .frame(height: 150)
                .padding(.trailing)
                .background(Color("Blue"))
                .clipShape(RoundedShape(corners: [.bottomRight]))
                .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack { Spacer() }
                    Text("Our Water Calculator")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text("Calculate Water Intake")
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Blue"))
                        .padding(.bottom)
                        .accessibilityAddTraits(.isHeader)
                }
                .frame(height: 90)
                .padding(.leading)
                
                
                
                Spacer()
                VStack {
                    if UIAccessibility.isVoiceOverRunning {
                        TextField("Enter your weight in kilo grams", text: $wightIn)
                            .padding(.horizontal)
                            .tint(Color.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 65)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color("lightShadow"), radius: 5, x: 0, y: 0.5)
                            .padding(.horizontal)
                            .padding(.top)
                            .focused($amountIsFocused)
                    } else {
                        LabeledContent {
                            VStack(alignment: .trailing) {
                                TextField("", text: $wightIn)
                                    .padding(.leading, 35)
                                //                                .keyboardType(.decimalPad)
                                    .focused($amountIsFocused)
                                    .foregroundColor(Color.white)
                                    .frame(width: 90)
                                    .frame(height: 35)
                                    .background(Color("Blue"))
                                    .cornerRadius(10)
                                    .padding()
                                //       .padding(.horizontal)
                                //.padding(.leading, 80)
                            }
                        } label: {
                            Text("your weight in kg")
                                .padding(.leading, 30)
                        }
                        
                        
                        //.font(.headline)
                        .tint(Color.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 65)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color("lightShadow"), radius: 5, x: 0, y: 0.5)
                        .padding(.horizontal)
                        .padding(.top)
                    }
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
                    .frame(height: 65)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color("lightShadow"), radius: 5, x: 0, y: 0.5)
                    .padding(.horizontal)
                    .padding(.top, 20)
        
                    Spacer()

                    Button {
                        guard !wightIn.isEmpty else { return }
                        let wieghtD = Double(wightIn)
                        Calculator(weightIn: wieghtD ?? 0.0, activityIn: activity, weatherIn: weather)
                        
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
                    .padding(.bottom, 30)
                    .fullScreenCover(isPresented: $showDrop) {
                        ContentView()
                    }
                   
                }
                
            }
            
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
            
            .navigationBarItems(leading: Button(action : {
                self.mode.wrappedValue.dismiss()
            }){
                if !vm.savedEntities.isEmpty {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.white)
                }
            })
            .frame(maxWidth: .infinity, maxHeight : .infinity)
            
            
        Spacer()
    
    .edgesIgnoringSafeArea(.top)
    .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
    
        if(value.startLocation.x < 20 && value.translation.width > 100) {
            self.mode.wrappedValue.dismiss()
        }
        
    }))
        }
        .navigationBarBackButtonHidden(true)
            
                     
            
        
        
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

