//
//  NumbersListView.swift
//  Demo
//
//  Created by Brad Lindsay on 3/8/23.
//

import SwiftUI

struct NumbersListView: View {
    @State var selected = 0
    @State var showAlert = false
    
    var body: some View {
        List(1..<101) { index in
            Button("Row \(index)") {
                selected = index
                showAlert = true
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.black)
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Number"), message: Text(String(selected)))
        }.navigationTitle(Text("Numbers"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NumbersListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NumbersListView()
        }
    }
}
