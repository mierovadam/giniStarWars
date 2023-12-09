//
//  PeopleViewModel.swift
//  AdamGiniInterview
//
//  Created by aaaaa on 22/11/2023.
//

import Foundation
import Combine

class PeopleViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var isFetching = false
    
    private var totalResults = 0
    private var nextUrl = ""
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        callGetNextPage()
    }

    
    //Combine
    func callGetNextPage() {
        isFetching = true
        guard let url = URL(string: nextUrl.isEmpty ? "https://swapi.dev/api/people/?page=1" : nextUrl) else {return}

        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: PeopleResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] (parsedResponse) in
                self?.handlePeopleResponse(response: parsedResponse)
                self?.isFetching = false
            })
            .store(in: &cancellables)
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }

    func handlePeopleResponse(response: PeopleResponse) {
        self.people.append(contentsOf: response.results)
        self.totalResults = response.count
        self.nextUrl = response.next ?? ""
        self.isFetching = false
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

}
