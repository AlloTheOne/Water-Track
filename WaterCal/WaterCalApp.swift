//
//  WaterCalApp.swift
//  WaterCal
//
//  Created by Alaa Alabdullah on 11/01/2023.
//

import SwiftUI

@main
struct WaterCalApp: App {
    @StateObject var vm = CoreDataBootcamp()
    var body: some Scene {
        WindowGroup {
            
            if vm.savedEntities.isEmpty {
                Form()
            } else {
                ContentView()
            }
           
            
        }
    }
}
