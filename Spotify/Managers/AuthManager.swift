//
//  AuthManager.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 28.01.2024.
//

import Foundation

 class AuthManager{
  static let shared = AuthManager()
     struct Constants {
         static let clientID="1764b73ec3374c67aa90ea12c1e95626"
         static let clientSecret="3d6dff8779534313b3cc25a850eaf7a7"
         static let tokenAPIURL = "https://accounts.spotify.com/api/token"
         static let redirectURI="https://www.vera.tc/"
         static let scopes="user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read"
     }
     private init(){}
     public var signInURL:URL?{
         let base = "https://accounts.spotify.com/authorize"
         let string="\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
         return URL(string: string)
     }
     var isSignedIn:Bool{
         return accessToken != nil
     }
     var deleteAccessToken:Void?{
        UserDefaults.standard.set(nil, forKey: "access_token")
    }
     private var accessToken:String?{
         return UserDefaults.standard.string(forKey: "access_token")
     }
     private var refreshToken:String?{
         return UserDefaults.standard.string(forKey: "refresh_token")
     }
     private var tokenExpirationDate:Date?{
         return UserDefaults.standard.object(forKey: "expirationData") as? Date
     }
     private var shouldRefreshToken:Bool{
         guard let expirationDate=tokenExpirationDate else {
             return false
         }
         let currentDate=Date()
         let fiveMinutes:TimeInterval=300
         return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
     }
     public func exchangeCodeForToken(code:String,completion: @escaping ((Bool)->Void)){
         guard let url=URL(string: Constants.tokenAPIURL) else { return}
         var components=URLComponents()
         components.queryItems=[
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
         ]
         var request=URLRequest(url: url)
         request.httpMethod="POST"
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.httpBody=components.query?.data(using: .utf8)
         let basicToken=Constants.clientID+":"+Constants.clientSecret
         let data=basicToken.data(using: .utf8)
         guard let base64String=data?.base64EncodedString() else {
             print("Failure to get base 64")
             completion(false)
             return
         }
         print(base64String)

         request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
             guard let data=data,error == nil else {
                 completion(false)
                 return
             }
             do{
                 let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                 self.cacheToken(result:result)
                 completion(true)
             }
             catch{
                 print(error.localizedDescription)
                 completion(false)
             }
         }
         task.resume()
     }
     public func refreshIfNeeded(completion:@escaping(Bool)->Void){
         guard shouldRefreshToken else {
             completion(true)
             return
         }
         guard let refreshToken = self.refreshToken else{
             return
         }
         guard let url=URL(string: Constants.tokenAPIURL) else { return}
         var components=URLComponents()
         components.queryItems=[
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
         ]
         var request=URLRequest(url: url)
         request.httpMethod="POST"
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         request.httpBody=components.query?.data(using: .utf8)
         let basicToken=Constants.clientID+":"+Constants.clientSecret
         let data=basicToken.data(using: .utf8)
         guard let base64String=data?.base64EncodedString() else {
             print("Failure to get base 64")
             completion(false)
             return
         }
         request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, _ ,error in
             guard let data=data,error == nil else {
                 completion(false)
                 return
             }
             do{
                 let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                 print("Successfully refreshed")
                 self.cacheToken(result:result)
                 completion(true)
             }
             catch{
                 print(error.localizedDescription)
                 completion(false)
             }
         }
         task.resume()
         
     }
     private func cacheToken(result:AuthResponse){
         UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
         if let refresh_token = result.refresh_token{
             UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
         }
         UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
         
     }
     public func signOut(completion:(Bool)->Void){
         UserDefaults.standard.setValue(nil, forKey: "access_token")
         UserDefaults.standard.setValue(nil, forKey: "refresh_token")
         UserDefaults.standard.setValue(nil, forKey: "expirationDate")
         completion(true)
     }
   
     
}
