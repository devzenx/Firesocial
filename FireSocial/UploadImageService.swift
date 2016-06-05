//
//  UploadImageService.swift
//  FireSocial
//
//  Created by yusuf_kildan on 05/06/16.
//  Copyright © 2016 yusuf_kildan. All rights reserved.
//

import Foundation
import Alamofire
class UploadImageService {
    static let instance = UploadImageService()
    var imageLink : String!
    func upload(image : UIImage , completion : (result : String) -> ()){
        let url = NSURL(string: "https://post.imageshack.us/upload_api.php")!
        //Alamofire request must be data format for Post Request
        let imageData = UIImageJPEGRepresentation(image, 0.2)!//1=No compression
        let keyData = "3IXRBAZW7ce8c1be6a16b5acd0841fa41eac3694".dataUsingEncoding(NSUTF8StringEncoding)!
        let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
        Alamofire.upload(.POST , url , multipartFormData : { multipartFormData in
            multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
            multipartFormData.appendBodyPart(data: keyData, name: "key")
            multipartFormData.appendBodyPart(data: keyJSON, name: "format")
        }){
            encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
                    if let info = response.result.value as? Dictionary<String , AnyObject> {
                        if let links = info["links"] as? Dictionary<String,AnyObject> {
                            if let link = links["image_link"] as? String {
                                self.imageLink = link
                                completion(result: self.imageLink)

                            }
                        }
                    }
                }
            case .Failure(let encodingError):
                print(encodingError)
            }
            
        }
        
        
        
    }
}