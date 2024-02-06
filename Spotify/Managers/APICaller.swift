//
//  APICaller.swift
//  Spotify
//
//  Created by Muhammet Ali Yahyaoğlu on 29.01.2024.
//

import Foundation

class APICaller{
    static let shared=APICaller()
    private init() {}
    
    enum HTTPMethod:String{
    case GET
    case POST
    case DELETE
    }
    struct Constants {
        static let baseURL="https://api.spotify.com/v1"
    }
    enum APIError:Error{
        case failedToGetData
    }
    public func getAlbumDetails(for album:Album , completion:@escaping(Result<AlbumDetailModel,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/albums/"+"\(album.id)"), type: .GET) { baseRequest in
           let task = URLSession.shared.dataTask(with: baseRequest){ data , _, error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return }
                do{
                    let result = try JSONDecoder().decode(AlbumDetailModel.self,from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                    print(error)
                }
                
            }
            task.resume()
        }
    }
    public func getPlaylistDetails(for playlist:PlayList , completion:@escaping(Result<PlaylistDetailModel,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/playlists/"+"\(playlist.id)"), type: .GET) { baseRequest in
           let task = URLSession.shared.dataTask(with: baseRequest){ data , _, error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return }
                do{
                    let result = try JSONDecoder().decode(PlaylistDetailModel.self,from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                    print(error)
                }
                
            }
            task.resume()
        }
    }
    public func getCategories(completion:@escaping (Result<CategoryModel,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/browse/categories?limit=10"), type: .GET) { baseRequest in
            let task=URLSession.shared.dataTask(with: baseRequest){ data , _ , error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result=try JSONDecoder().decode(CategoryModel.self, from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                    print(error)
                }
            }
            task.resume()
        }
    }
    public func getCategoryDetails(with model:CategoryItem ,completion:@escaping(Result<[PlayList],Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/browse/categories/"+model.id+"/playlists?limit=8"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){  data,  _ , error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result=try JSONDecoder().decode(FeaturedPlaylistsResponse.self,from: data)
                    let playlist=result.playlists.items
                    completion(.success(playlist))
                    
                }
                catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()

        }
        
    }
    public func search(with query:String,completion:@escaping (Result<[SearchResult],Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/search?limit=5&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { baseRequest in
            print(baseRequest.url?.absoluteString ?? "")
            let task = URLSession.shared.dataTask(with: baseRequest) { data , _ , error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return }
                do{
                    let result = try JSONDecoder().decode(SearchResultModel.self, from: data)
                    var searchResults:[SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({.track(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({.artist(model: $0)}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({.playlist(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap({.album(model: $0)}))
                    completion(.success(searchResults))
                }
                catch{
                    completion(.failure(error))
                    print(error)
                }
            }
            task.resume()
        }
        
    }
    public func getCurrentUserProfile(completion:@escaping(Result<UserModel,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data, _ , error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(UserModel.self,from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                    print(error)
                }
                
            }
            task.resume()
        }
    }
    public func getNewReleases(completion: @escaping(Result<NewReleasesModel, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseURL+"/browse/new-releases?limit=50"), type: .GET) { baseRequest in
            let task=URLSession.shared.dataTask(with: baseRequest){ data, _ , error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result=try JSONDecoder().decode(NewReleasesModel.self,from: data)
                    completion(.success(result))
                }
                
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    public func getRecommendations(genres:Set<String>,completion: @escaping (Result<RecommendationResponse,Error>)->Void){
        let seeds=genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseURL+"/recommendations?seed_genres=\(seeds)"), type: .GET) { baseRequest in
            let task=URLSession.shared.dataTask(with: baseRequest){ data, _ , error in
                guard let data=data , error==nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result = try JSONDecoder().decode(RecommendationResponse.self,from: data)
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                    print(error)
                }
                
            }
            task.resume()
        }
        
    }
    public func getRecommendedGenres(completion:@escaping(Result<RecommendedGenresModel,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/recommendations/available-genre-seeds"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data , _ , error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result=try JSONDecoder().decode(RecommendedGenresModel.self,from: data)
                     completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                    
                }
                
            }
            task.resume()
        }
        
    }
    public func getFeaturedPlaylist(completion:@escaping(Result<FeaturedPlaylistsResponse,Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/browse/featured-playlists?limit=5"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){ data , _ , error in
                guard let data=data,error==nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do{
                    let result=try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                
                }
                catch{
                    completion(.failure(error))
                    
                }
                
            }
            task.resume()
        }
        
    }
    public func getCurrentUserPlaylists(completion:@escaping(Result<[PlayList],Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/me/playlists/?limit=50"), type: .GET) { baseRequest in
          let task =  URLSession.shared.dataTask(with: baseRequest){ data , _ , error in
                guard let data = data , error == nil else{
                    completion(.failure(APIError.failedToGetData))
                     return
                }
                do {
                    let task = try JSONDecoder().decode(LibraryPlaylistsResponse.self,from: data)
                    completion(.success(task.items))
                }
                catch{
                    completion(.failure(error))
                }
          }
            task.resume()
        }
    }
    public func createPlaylist(with name:String,completion:@escaping (Bool)->Void){
        getCurrentUserProfile { [weak self ]result in
            switch result {
            case .success(let profile):
                let urlString=Constants.baseURL+"/users/\(profile.id)/playlists"
                
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request=baseRequest
                    let json=[
                            "name": name,
                            "description": "New playlist description",
                            "public": false
                    ]
                    
                    request.httpBody=try? JSONSerialization.data(withJSONObject: json,options: .fragmentsAllowed)
                    let task = URLSession.shared.dataTask(with: request){
                        data , _ , error in
                        guard let data=data,error==nil else {
                            completion(false)
                            return}
                        do{
                            let result = try JSONDecoder().decode(PlayList.self,from: data)
                             completion(true)
                        }
                        catch{
                            print(error.localizedDescription)
                            completion(false)
                            
                        }
                    }
                    task.resume()
                }
            case .failure(_):
                completion(false)
            }
        }
        
    }

    public func removeTrackFromPlaylist(track:AudioTrack, playlist:PlayList, completion:@escaping(Bool)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
            var request=baseRequest
            let json: [String: Any] = [
                "tracks": [
                    ["uri": "spotify:track:\(track.id)"]
                ],
                "snapshot_id": ""
            ]
            request.httpBody=try? JSONSerialization.data(withJSONObject: json,options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request){
                data , response , error in
                guard let httpResponse=response as? HTTPURLResponse, let data=data,error==nil else {
                    completion(false)
                    return
                }
                do{
                    let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print(httpResponse.statusCode)
                    completion(true)
                }
                catch{
                    print(error)
                    completion(false)
                }
                
            }
            task.resume()
        }
        
    }
    
    public func getCurrentUserAlbums(completion:@escaping (Result<[Album],Error>)->Void){
        createRequest(with: URL(string: Constants.baseURL+"/me/albums"), type: .GET) { baseRequest in
          let task =  URLSession.shared.dataTask(with: baseRequest){ data , _ ,error in
              guard let data=data,error==nil else {
                  completion(.failure(APIError.failedToGetData))
                  return
              }
              do{
                  let result = try JSONSerialization.jsonObject(with: data)
                  print(result)
              }
              catch{
                  completion(.failure(error))
                  print(error)
              }
                
                
            }
            task.resume()
        }
        
    }
    public func addTrackToPlayList(track: AudioTrack, playlist: PlayList, completion: @escaping (Bool) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/playlists/" + playlist.id + "/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = ["uris": ["spotify:track:\(track.id)"]]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(false)
                    print(error)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        completion(true)
                    } catch {
                        completion(false)
                        print(error)
                    }
                } else {
                    completion(false)
                    print("Unexpected response: \(response)")
                }
            }

            task.resume()
        }
    }



    
    
    private func createRequest(
        with url:URL?,
        type:HTTPMethod,
        completion:@escaping(URLRequest)->Void){
        guard let apiURL=url else {
            return
        }
        var request=URLRequest(url: apiURL)
            request.setValue("Bearer \(UserDefaults.standard.string(forKey: "access_token") ?? "")", forHTTPHeaderField: "Authorization")
            request.timeoutInterval=30
            request.httpMethod=type.rawValue
            completion(request)
    }
    
    
    
        
}
