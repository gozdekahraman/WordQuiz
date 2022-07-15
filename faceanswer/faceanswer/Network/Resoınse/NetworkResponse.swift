//
//  NetworkResponse.swift
//  faceanswer
//
//  Created by gozde kahraman on 12.07.2022.
//

import Foundation

struct NetworkResponse<ResponseModel: Decodable> {
    let httpStatus: HTTPStatus
    let response: ResponseModel

    init(urlResponse: HTTPURLResponse, with data: Data) throws {
        httpStatus = HTTPStatus(response: urlResponse)
        response = try JSONDecoder().decode(ResponseModel.self, from: data)
    }
}

enum HTTPStatus {
    case success
    case badRequest
    case serverError
    case unRecognizedError

    init(response: HTTPURLResponse) {
        self.init(statusCode: response.statusCode)
    }

    init(statusCode: Int) {
        switch statusCode {
        case 200...299:
            self = .success
        case 400:
            self = .badRequest
        case 500...600:
            self = .serverError
        default:
            self = .unRecognizedError
        }
    }
}
