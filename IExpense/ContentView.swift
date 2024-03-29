//
//  ContentView.swift
//  IExpense
//
//  Created by Luc Derosne on 29/10/2019.
//  Copyright © 2019 Luc Derosne. All rights reserved.
//
// IEExpense Wrapup J38

import SwiftUI

struct ExpenseItem: Identifiable, Codable  {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }

    //@Published var items = [ExpenseItem]()
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }

}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
//                ForEach(expenses.items, id: \.id) { item in
//                    Text(item.name)
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                
                        Spacer()
                        self.itemStyle(amount: item.amount)
                        //Text("$\(item.amount)")
                    }
                }

                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
//                Button(action: {
//                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
//                    self.expenses.items.append(expense)
//                }) {
//                    Image(systemName: "plus")
//                }
            )

        }.sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }

    }
    func itemStyle(amount: Int) -> Text {
        if amount < 10 {
            return Text("$\(amount)").foregroundColor(.green)
            
        } else if amount > 100 {
            return Text("$\(amount)").foregroundColor(.red)
        } else {
            return Text("$\(amount)").foregroundColor(.blue)
        }
    }
    
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

