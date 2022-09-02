//
//  CatApi.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 8/29/22.
//

import Foundation

protocol CatApiRequestDelegate: AnyObject {
    func didUpdate(error: CatApiError?)
}

enum CatApiError: Error {
    case failure(Error)
    case invalidUrl(String)
    case invalidData
    case decodingFailure
}

extension CatApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failure(let error):
            return "Failure: \(error.localizedDescription)"
        case .invalidUrl(let url):
            return "Invalid URL: \(url)"
        case .invalidData:
            return "Invalid data"
        case .decodingFailure:
            return "Decoding failure"
        }
    }
}

class CatApi {
    typealias FetchBreedsCompletionBlock = (Result<[CatBreed], CatApiError>) -> Void
    typealias FetchBreedImagesCompletionBlock = (Result<[CatBreedImage], CatApiError>) -> Void

    static let shared = CatApi()

    private let baseUrl: String

    init (baseUrl: String = "https://api.thecatapi.com/v1") {
        self.baseUrl = baseUrl
    }

    func fetchBreeds(completion: @escaping FetchBreedsCompletionBlock) {
        let urlString = "\(baseUrl)/breeds"
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidUrl(urlString)))
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                return completion(.failure(.failure(error)))
            }
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            do {
                let catBreeds = try JSONDecoder().decode([CatBreed].self, from: data)
                return completion(.success(catBreeds))
            } catch {
                return completion(.failure(.failure(error)))
            }
        }
        task.resume()
    }

    func fetchBreedImagess(breed: CatBreed,
                           completion: @escaping FetchBreedImagesCompletionBlock) {
        let urlString = "\(baseUrl)/images/search?breed_ids=beng&limit=8"
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidUrl(urlString)))
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if let error = error {
                return completion(.failure(.failure(error)))
            }
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            do {
                let catBreedImages = try JSONDecoder().decode([CatBreedImage].self, from: data)
                return completion(.success(catBreedImages))
            } catch {
                return completion(.failure(.failure(error)))
            }
        }
        task.resume()
    }
}
