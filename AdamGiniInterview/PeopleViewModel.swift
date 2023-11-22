//
//  PeopleViewModel.swift
//  AdamGiniInterview
//
//  Created by aaaaa on 22/11/2023.
//

import Foundation

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var isFetching = false
    
    private var totalResults = 0
    private var nextUrl = ""

    func loadInitialData() {
        isFetching = true
        RequestManager.shared.getPeople(nextUrl: nextUrl) { [weak self] response in
            self?.handleResult(response)
        }
    }

    func loadMoreData() {
        if totalResults == people.count{ return }
        isFetching = true
        RequestManager.shared.getPeople(nextUrl: nextUrl) { [weak self] response in
            self?.handleResult(response)
        }
    }

    func toggleSelection(for person: Person) {
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            if person.isSelected {
                people[index].isSelected.toggle()
            } else {
                people.indices.forEach { people[$0].isSelected = false }
                people[index].isSelected.toggle()
            }
        }
    }

    func isLastPerson(_ person: Person) -> Bool {
        person.id == people.last?.id
    }

    private func handleResult(_ response: Result<PeopleResponse, Error>) {
        DispatchQueue.main.async {
            self.isFetching = false
            switch response {
            case .success(let response):
                self.people.append(contentsOf: response.results)
                self.nextUrl = response.next ?? ""
                self.totalResults = response.count
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
