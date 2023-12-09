//
//  ContentView.swift
//  AdamGiniInterview
//
//  Created by aaaaa on 22/11/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PeopleViewModel()

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.people) { person in
                    PersonRowView(person: person, isSelected: person.isSelected) {
                        viewModel.toggleSelection(for: person)
                    }
                    .onAppear {
                        if viewModel.isLastPerson(person) && !viewModel.isFetching {
                            viewModel.callGetNextPage()
                        }
                    }
                }
                if viewModel.isFetching {
                    ProgressView()
                        .padding(32)
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

struct PersonRowView: View {
    let person: Person
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                Text(person.name)
                Spacer()
                Text(person.height)
            }
            .padding(32)
            .background(isSelected ? Color.red : Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2)
            )
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
