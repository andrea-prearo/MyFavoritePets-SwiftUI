//
//  CatApi.swift
//  MyFavoritePets
//
//  Created by Andrea Prearo on 8/29/22.
//

import Foundation

enum CatApiError: Error {
    case unknown
    case failure(Error)
    case invalidUrl(String)
    case networkError(reason: String)
    case invalidData
    case decodingFailure
}

extension CatApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown failure"
        case .failure(let error):
            return "Failure: \(error.localizedDescription)"
        case .invalidUrl(let url):
            return "Invalid URL: \(url)"
        case .networkError(let reason):
            return "API error: \(reason)"
        case .invalidData:
            return "Invalid data"
        case .decodingFailure:
            return "Decoding failure"
        }
    }
}

class CatApi {
    private let baseUrl: String

    init (baseUrl: String = "https://api.thecatapi.com/v1") {
        self.baseUrl = baseUrl
    }

    func fetchBreeds() async throws -> [CatBreed] {
        let urlString = "\(baseUrl)/breeds"
        guard let url = URL(string: urlString) else {
            throw CatApiError.invalidUrl(urlString)
        }

        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CatApiError.unknown
        }
        if (httpResponse.statusCode == 401) {
            throw CatApiError.networkError(reason: "Unauthorized")
        }
        if (httpResponse.statusCode == 403) {
            throw CatApiError.networkError(reason: "Resource forbidden")
        }
        if (httpResponse.statusCode == 404) {
            throw CatApiError.networkError(reason: "Resource not found")
        }
        if (405..<500 ~= httpResponse.statusCode) {
            throw CatApiError.networkError(reason: "client error")
        }
        if (500..<600 ~= httpResponse.statusCode) {
            throw CatApiError.networkError(reason: "server error")
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let catBreeds = try decoder.decode([CatBreed].self, from: data)
            return catBreeds
        } catch {
            throw CatApiError.failure(error)
        }
    }

    func fetchBreedImages(breed: CatBreed) async throws -> [CatBreedImage] {
        let urlString = "\(baseUrl)/images/search?breed_ids=\(breed.id)&limit=8"
        guard let url = URL(string: urlString) else {
            throw CatApiError.invalidUrl(urlString)
        }

        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CatApiError.unknown
        }
        if (httpResponse.statusCode == 401) {
            throw CatApiError.networkError(reason: "Unauthorized")
        }
        if (httpResponse.statusCode == 403) {
            throw CatApiError.networkError(reason: "Resource forbidden")
        }
        if (httpResponse.statusCode == 404) {
            throw CatApiError.networkError(reason: "Resource not found")
        }
        if (405..<500 ~= httpResponse.statusCode) {
            throw CatApiError.networkError(reason: "client error")
        }
        if (500..<600 ~= httpResponse.statusCode) {
            throw CatApiError.networkError(reason: "server error")
        }
        do {
            let catBreedImages = try JSONDecoder().decode([CatBreedImage].self, from: data)
            return catBreedImages
        } catch {
            throw CatApiError.failure(error)
        }
    }
}
