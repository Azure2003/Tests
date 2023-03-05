//
//  ActualInterface.swift
//  Tester
//
//  Created by Alex Zhou on 2/1/23.
//

import SwiftUI
import AVFoundation
struct ActualInterface: View {
    
    @State private var messages: String=""
    @ObservedObject private var keyboard=KeyboardResponder()
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order:.forward)]) var Testers: FetchedResults<Testers>
    @Environment(\.managedObjectContext) var moc
    init(){
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    var body: some View {
            VStack (){
                //ScrollView{
                    List{
                        ForEach(Testers) { datum in
                            MessageView(currentMessage: datum)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listStyle(.plain)
                        }
                    }
                //}
                HStack{
                    TextField("Messages...", text: $messages)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                    Button("Send"){
                        let newMessage=Tester.Testers(context: moc)
                        newMessage.message=messages
                        newMessage.id=UUID()
                        newMessage.date=Date().timeIntervalSinceReferenceDate
                        newMessage.isCurrentUser=true
                        try? moc.save()
                        messages=""
                        let utterance=AVSpeechUtterance(string: messages)
                        utterance.voice=AVSpeechSynthesisVoice(language: "en-US")
                        utterance.pitchMultiplier=2.0
                        utterance.rate=0.3
                        let syn=AVSpeechSynthesizer()
                        syn.speak(utterance)
                    }
                }.frame(minHeight: CGFloat(50)).padding()
            }
            .padding(.bottom, keyboard.currentHeight)
    }

}
struct MessageView : View {
    var currentMessage: Testers
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if currentMessage.isCurrentUser{
                Spacer()
            }
            ContentMessageView(contentMessage: currentMessage.message ?? "Unknown",
                               isCurrentUser: currentMessage.isCurrentUser)
        }
    }
}
struct ContentMessageView: View{
    var contentMessage: String
    var isCurrentUser:Bool
    var body: some View{
        HStack(alignment: .center){
            Text(contentMessage)
                .padding(10)
                .foregroundColor(isCurrentUser ? Color.white: Color.black)
                .background(isCurrentUser ? Color.blue: Color(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha:1.0)))
                .cornerRadius(10)
        }
        
        
    }
}
struct ActualInterface_Previews: PreviewProvider {
    static var previews: some View {
        ActualInterface()
    }
}
