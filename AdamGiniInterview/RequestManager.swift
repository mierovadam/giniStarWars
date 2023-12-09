//
//  RequestManager.swift
//  AdamGiniInterview
//
//  Created by aaaaa on 22/11/2023.
//

import Foundation

//struct Constants {
//    static let baseURL = "https://swapi.dev/api"
//}

class RequestManager {
    static let shared = RequestManager()
    
    func getPeople(nextUrl: String, completion: @escaping (Result<PeopleResponse, Error>) -> Void) {
        guard let url = URL(string: nextUrl.isEmpty ? "https://swapi.dev/api/people/?page=1" : nextUrl) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(PeopleResponse.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}


struct PeopleResponse: Codable {
    let results: [Person]
    let count: Int
    let next: String?
}

struct Person: Codable, Hashable, Identifiable {
    let id = UUID()
    var isSelected: Bool = false

    let name: String
    let height: String

    enum CodingKeys: String, CodingKey {
        case name, height
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decode(String.self, forKey: .height)

        self.isSelected = false
    }
}

//
//private func handleResult(_ response: Result<PeopleResponse, Error>) {
//    DispatchQueue.main.async {
//        self.isFetching = false
//        switch response {
//        case .success(let response):
//            self.people.append(contentsOf: response.results)
//            self.nextUrl = response.next ?? ""
//            self.totalResults = response.count
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//    }
//}


/*

func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
    guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
    let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
            completion(.success(results.results))
        } catch {
            completion(.failure(APIError.failedTogetData))
        }
        
    }
    
    task.resume()
            
}

private func configureHeroHeaderView() {
    ApiCaller.shared.getTrendingMovies { [weak self] result in
        switch result {
        case .success(let titles):
            let selectedTitle = titles.randomElement()
            
            self?.randomTrendingMovie = selectedTitle
            self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            
        case .failure(let erorr):
            print(erorr.localizedDescription)
        }
    }
}

*/
