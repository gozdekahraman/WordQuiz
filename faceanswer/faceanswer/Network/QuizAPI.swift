//
//  QuizAPI.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation

struct QuizRequestModel {
    let level: Int = 3
    let area: String?
}

class QuizAPI {
    func fetchQuiz(with requestModel: QuizRequestModel, completion: @escaping (Result<NetworkResponse<QuizResponseModel>, Error>) ->  Void) {
        let headers = [
            "X-RapidAPI-Key": "351e61beb5msh714daa1c21572abp1ac5a4jsn801d0b487ea5",
            "X-RapidAPI-Host": "twinword-word-association-quiz.p.rapidapi.com"
        ]

        var path = "https://twinword-word-association-quiz.p.rapidapi.com/type1/?level=\(String(requestModel.level))"
        if let area = requestModel.area {
            path += "&area=\(area)"
        }
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data, let response = response as? HTTPURLResponse {
                    do {
                        let networkResponse = try NetworkResponse<QuizResponseModel>.init(urlResponse: response, with: data)
                        completion(.success(networkResponse))
                    } catch {
                       print("Decoding error")
                    }
                }
            }

        })
        dataTask.resume()
    }
}
