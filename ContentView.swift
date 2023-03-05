//
//  ContentView.swift
//  Shared
//
//  Created by Alex Zhou on 11/26/22.
//

import SwiftUI
struct ContentView: View {
    @StateObject private var dataController=DataController()
    var body: some View {
        NavigationView{
            NavigationLink(destination: ActualInterface()){
                Text("Start a new session!")
                
            }
        } .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

