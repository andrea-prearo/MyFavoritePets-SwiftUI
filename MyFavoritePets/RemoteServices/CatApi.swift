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
    static let shared = CatApi()

    private let baseUrl: String

    init (baseUrl: String = "https://api.thecatapi.com/v1") {
        self.baseUrl = baseUrl
    }

    func fetchBreeds() async throws -> [CatBreed] {
        let urlString = "\(baseUrl)/breeds"
        guard let url = URL(string: urlString) else {
            throw CatApiError.invalidUrl(urlString)
        }

        return try await withUnsafeThrowingContinuation { continuation in
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    return continuation.resume(throwing: CatApiError.failure(error))
                }
                guard let data = data else {
                    return continuation.resume(throwing: CatApiError.invalidData)
                }
                do {
                    let catBreeds = try JSONDecoder().decode([CatBreed].self, from: data)
                    return continuation.resume(returning: catBreeds)
                } catch {
                    return continuation.resume(throwing: CatApiError.failure(error))
                }
            }
            task.resume()
        }
    }

    func fetchBreedImages(breed: CatBreed) async throws -> [CatBreedImage] {
        let urlString = "\(baseUrl)/images/search?breed_ids=\(breed.id)&limit=8"
        guard let url = URL(string: urlString) else {
            throw CatApiError.invalidUrl(urlString)
        }

        return try await withUnsafeThrowingContinuation { continuation in
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    return continuation.resume(throwing: CatApiError.failure(error))
                }
                guard let data = data else {
                    return continuation.resume(throwing: CatApiError.invalidData)
                }
                do {
                    let catBreedImages = try JSONDecoder().decode([CatBreedImage].self, from: data)
                    return continuation.resume(returning: catBreedImages)
                } catch {
                    return continuation.resume(throwing: CatApiError.failure(error))
                }
            }
            task.resume()
        }
    }
}
