//
//  ContentView.swift
//  SearchBar
//
//  Created by Dhaval Gevariya on 27/05/20.
//  Copyright © 2020 Dhaval Gevariya. All rights reserved.
//

import SwiftUI
var array = ["Kapil Dev", "Dilip Vengsarkar", "Sachin Tendulkar", "Sourav Ganguly", "Rahul Dravid", "Virender Sehwag", "Virat Kohli", "Mahendra Sign Dhoni"]
var isShowView = Bool()
struct ContentView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                // Search view
                SearchBarView(searchText: $searchText).transition(.move(edge: .top))
                ZStack
                    {
                        List {
                            // Filtered list of names
                            ForEach(array.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self) {
                                searchText in
                                
                                HStack
                                    {
                                        Image(systemName: "person")
                                        Text(searchText).fontWeight(.medium)
                                }
                            }
                        }
                        .navigationBarTitle(Text("Search"))
                        .animation(.easeInOut)
                        .resignKeyboardOnDragGesture()
                        if searchText == ""
                        {
                            
                        }
                        else
                        {
                            Rectangle()
                                .fill(Color.gray)
                                .opacity(0.3)
                                .edgesIgnoringSafeArea(.bottom)
                            
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .light)
            
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}


struct SearchBarView: View {
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    var onCommit: () ->Void = {print("onCommit")}
    
    var body: some View {
        HStack {
            
            HStack {
                Image(systemName: "magnifyingglass")
                
                // Search text field
                ZStack (alignment: .leading) {
                    if searchText.isEmpty { // Separate text for placeholder to give it the proper color
                        Text("Cricketer,Singer and More").font(.system(size: 16))
                    }
                    TextField("", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: onCommit).foregroundColor(.primary)
                }
                //Clear button
                Button(action: {
                    self.searchText = ""
                }) {
                    
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary) // For magnifying glass and placeholder test
                .background(Color(.tertiarySystemFill))
                .cornerRadius(10.0)
            if showCancelButton  {
                // Cancel button
                Button("Cancel") {
                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                    self.searchText = ""
                    self.showCancelButton = false
                    //isShowView = false
                }
                .foregroundColor(Color(.systemBlue))
            }
            
        }
        .padding(.horizontal)
        .animation(.easeInOut)
        .navigationBarHidden(showCancelButton)
    }
}

