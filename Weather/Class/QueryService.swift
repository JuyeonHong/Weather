//
//  QueryService.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2020/01/13.
//  Copyright © 2020 hongjuyeon_dev. All rights reserved.
//

import Foundation

class QueryService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let key = getWeatherAPIString()
    
    ///URLSessionConfiguration
    /// default: disk에 의존하는 글로벌 캐시, 쿠키, credential 저장
    /// ephemeral: 전부 메모리에 저장 => private session
    /// background: 다운로드 또는 업로드할 때 백그라운드에서 돔. 앱이 죽거나 중단될 때까지 지속
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    typealias JSonDictionary = [String: Any]
    typealias QueryResult = (JSonDictionary) -> Void
    
    func getSearchResults(latitude: Double, longitude: Double, searchData: DataType, completion: @escaping QueryResult) {
        // 새로운 쿼리를 사용하기 위해 기존의 dataTask를 취소함.
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: baseURL + searchData.rawValue) {
            urlComponents.query = String(format: "APPID=%@&lat=%f&lon=%f", key, latitude, longitude)
            
            guard let url = urlComponents.url else {
                print("URL is nill")
                return
            }
            print(url)
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer { // defer로 묶인 코드는 상관없이 함수 맨 마지막에 실행된다.
                    self?.dataTask = nil
                }
                
                if let error = error {
                    print("error: \(error.localizedDescription)")
                    if let errorCode = error as NSError?, errorCode.code == NSURLErrorTimedOut {
                        print("###Time out###")
                        return
                    }
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    // get search results
                    var responseData: JSonDictionary?
                    do {
                        responseData = try JSONSerialization.jsonObject(with: data, options: []) as? JSonDictionary
                    } catch let parseError as NSError {
                        print("JSONSerialization error: \(parseError.localizedDescription)")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        print("\(String(describing: responseData))")
                        completion(responseData!)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    static func getWeatherAPIString() -> String {
        var keyString = ""
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let valueDict = NSDictionary(contentsOfFile: path) {
            keyString = valueDict["OPEN_WEATHER_API_KEY"] as? String ?? ""
        }
        return keyString
    }
}
