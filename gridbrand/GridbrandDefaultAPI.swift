//
//  GridbrandAPI.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class GridbrandDefaultAPI : GridbrandAPI {
    let URLSession: Foundation.URLSession
    
    static let sharedAPI = GridbrandDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    func emailAvailable(_ email: String) -> Observable<Bool> {
        // this is ofc just mock, but good enough
        
        let url = URL(string: "https://github.com/\(email.URLEscaped)")!
        let request = URLRequest(url: url)
        return self.URLSession.rx.response(request: request)
            .map { (response, _) in
                return true;//response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    func signup(data: SignupModel) -> Observable<UserModel> {
        // Should make /signup REST API call
        let userDao = UserDao()
        let user = userDao.findById(1)!
        user.email = data.email
        user.fullname = data.fullname
        user.country = data.country
        
        AppSession.saveCurrentUser(user: user, accessToken: "FbS7dLaYTohe0OtlnJZcLwljCiCU58OCcgSGfH7HdDuXTqM8kC")
        
        return Observable.just(user)
    }
    
    func login(email: String, password: String) -> Observable<UserModel> {
        // Should make /login REST API call
        let userDao = UserDao()
        let user = userDao.findById(1)!
        
        AppSession.saveCurrentUser(user: user, accessToken: "FbS7dLaYTohe0OtlnJZcLwljCiCU58OCcgSGfH7HdDuXTqM8kC")
        
        return Observable.just(user)
    }
        
    func getCurrentUser(accessToken: String)->Observable<UserModel> {
        let url = URL(string: "http://127.0.0.1:3000/api/v1/me?access_token=\(accessToken)")!
        
        return request(.get, url, parameters: nil)
            .flatMap { request in
                request.rx.json()
            }
            .map { jsonResult in
                print(jsonResult)
                guard
                    let json = jsonResult as? Dictionary<String, Any>,
                    let resource = json["resource"] as? Dictionary<String, Any>
                else {
                    throw apiError("Parsing error")
                }
                return UserModel(data:resource)
            }
    }

    func requestEmailVerify(accessToken: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(accessToken)")!
        let request = URLRequest(url: url)
        return self.URLSession.rx.response(request: request)
            .map { (response, _) in
                return true;//response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    func requestResetPassword(email: String)->Observable<Bool> {
        // On backend
        // should find user with requested email and generate temp password
        // And backend should support login by temp password as well
        let url = URL(string: "https://github.com/\(email.URLEscaped)")!
        
//        return request(.get, url, parameters: nil)
//            .flatMap { request in
//                request.rx.string()
//            }
//            .map { result in
//                print(result)
//                return true
//            }
        return .just(true)
    }
    
    func reportCycle(cycleId: Int64)->Observable<Bool> {
        return .just(true)
    }
    
    
    func downloadCycleData(accessToken: String) -> DownloadRequest {

        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask, true)[0]
            let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
            let fileURL = documentsURL.appendingPathComponent("image.png")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories]) }
        
        return Alamofire.download("http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v", to:
            destination)
    }
}
