//
//  AddView.swift
//  IExpense
//
//  Created by Luc Derosne on 30/10/2019.
//  Copyright © 2019 Luc Derosne. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var showingAlert = false
    @ObservedObject var expenses: Expenses
    
    static let types = ["Business", "Personal"]

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    //.keyboardType(.default)
//                .sheet(isPresented: $showingAddExpense) {
//                    AddView(expenses: self.expenses)

//                }

            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                if let actualAmount = Int(self.amount) {
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showingAlert = true
                }
            })

        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Enter an Int"), message: Text("No letters please."), dismissButton: .default(Text("OK")) {
                self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
}


struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
