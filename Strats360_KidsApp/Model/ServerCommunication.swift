
import Foundation
import Alamofire


/// Server communication class
class ServerCommunication : NSObject {
    
    static let share = ServerCommunication()
    
    typealias CompletionHandler = ((_ response : ResponseModel) -> Void)
    typealias RegistrationCompletionHandler = ((_ response : ResponseDataModel) -> Void)

    func requestDataTask(requestObject: RequestModel, completionHandler:@escaping CompletionHandler) {
        
        guard let stringURL = requestObject.url else {
            return
        }
        AF.request(stringURL ,method: requestObject.httpMethod, parameters: requestObject.parameter, headers: requestObject.headerFields).response { response in
            print("URL : - \(requestObject.url!) \n PARAM :- \(requestObject.parameter!)")
            if(response.data == nil){
                if let status = response.response?.statusCode {

                    switch(status){
                    case 200,201,202:
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: response.error, data: nil)
                        completionHandler(responseModel)
                        break
                    case 203 ... 299:
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Response Error"]), data: nil)
                        completionHandler(responseModel)

                        break
                    case 300 ... 399:
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Redirection messages"]), data: nil)
                        completionHandler(responseModel)

                        break
                    case 400 :
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Bad Request"]), data: nil)
                        completionHandler(responseModel)
                        
                        break
                    case 401 :
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Unauthenticated access"]), data: nil)
                        completionHandler(responseModel)
                        
                        break
                    case 404 :
                        
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Server is not responding"]), data: nil)
                        completionHandler(responseModel)
                        
                        break
                    case 405 ... 498 :
                        
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Server is not responding"]), data: nil)
                        completionHandler(responseModel)
                        break
                        
                    case 499 ... 599:
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Server Error"]), data: nil)
                        completionHandler(responseModel)
                        
                        break
                        
                    default:
                        
                        let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: response.response!.statusCode, userInfo: [ NSLocalizedDescriptionKey: "Other Status Code"]), data: nil)
                        completionHandler(responseModel)
                    }
                }
                else {
                    
                    let responseModel = ResponseModel(statusCode: 404, error: NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Internet issue"]), data: nil, success: false)
                    completionHandler(responseModel)
                }
            }
            else {
//                var backToString = String(data: response.data!, encoding: String.Encoding.utf8) as String?
//                print(backToString as Any)
                
                let jsonData = ServerCommunication.share.nsdataToJSON(data: response.data! ) as! NSDictionary
                
                print(jsonData)
                
                var status : Int = 0
                   
                if let value = jsonData["status"] as? Int{
                    status             = Int(value)
                }
                if let value = jsonData["status"] as? Float{
                    status             = Int(value)
                }
                if let value = jsonData["status"] as? String{
                    status             = Int(value)!
                }
                if let value = jsonData["status"] as? Double{
                    status             = Int(value)
                }
                // Status is set as 1 beacause right now our server data is giving that as validation.
                if(status == 1) {
                    
                    let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: response.error, data: jsonData, success: true)
                    completionHandler(responseModel)
                    
                }
                else{
                    let responseModel = ResponseModel(statusCode: response.response!.statusCode, error: response.error, data: jsonData, success: false)
                    completionHandler(responseModel)
                }
            }
        }
    }
    
    func registrationRequestDataTask(requestObject: RequestModel, completionHandler:@escaping RegistrationCompletionHandler) {
        
        print("URL : - \(requestObject.url!) \n PARAM :- \(requestObject.parameter!)")
        
        guard let stringURL = requestObject.url else {
            return
        }
        AF.request(stringURL ,method: requestObject.httpMethod, parameters: requestObject.parameter, headers: requestObject.headerFields).response { response in
            if(response.data == nil){
                if((response.response?.statusCode) != nil){
                    let responseModel = ResponseDataModel(statusCode: response.response!.statusCode, error: response.error, data: nil, success: false)
                    completionHandler(responseModel)
                    
                }
                else {
                    
                    let responseModel = ResponseDataModel(statusCode: 404, error: NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Internet issue"]), data: nil, success: false)
                    completionHandler(responseModel)
                }
            }
            else {
                
                let jsonData = ServerCommunication.share.nsdataToJSON(data: response.data! ) as! NSDictionary
                print(jsonData)
                var status : Int!
                   
                if let value = jsonData["api_status"] as? Int{
                    status             = Int(value)
                }
                if let value = jsonData["api_status"] as? Float{
                    status             = Int(value)
                }
                if let value = jsonData["api_status"] as? String{
                    status             = Int(value)!
                }
                if let value = jsonData["api_status"] as? Double{
                    status             = Int(value)
                }

                if(status! == 200) {
                    let responseModel = ResponseDataModel(statusCode: response.response!.statusCode, error: response.error, data: response.data, success: true)
                    completionHandler(responseModel)
                    
                }
                else {
                    if(jsonData == NSDictionary()){
                        let responseModel = ResponseDataModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Server issue. Try after some time"]), data: response.data, success: false)
                        completionHandler(responseModel)
                        
                    }
                    else {
                        if let success = (jsonData.value(forKeyPath: "success"))  as? NSDictionary{
                            let responseModel = ResponseDataModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: (success.value(forKeyPath: "error_text") as! String)]), data: response.data, success: false)
                            completionHandler(responseModel)
                        }
                        
                        if let success = (jsonData.value(forKeyPath: "errors"))  as? NSDictionary{

                        let responseModel = ResponseDataModel(statusCode: response.response!.statusCode, error: NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: (success.value(forKeyPath: "error_text") as! String)]), data: response.data, success: false)
                        completionHandler(responseModel)
                        }
                    }
                }
            }
        }
    }
    
    func APICallingFunction(request : RequestModel, completion: @escaping (_ response : Bool,NSDictionary?) -> Void){
        
        self.requestDataTask(requestObject: request) { (response) in
//            Helper.progressHUD(.dismissProgress)
            if response.success {
                completion(true,response.data)
            }
            else {
                completion(false,response.data)
            }
        }
    }
    func nsdataToJSON(data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return NSDictionary()
    }
    
}

/// Request generate model
struct RequestModel {
    let url: String?
    var httpMethod: HTTPMethod = HTTPMethod.get
    var headerFields: HTTPHeaders? = nil
    var parameter: [String : Any]? = nil
    
}

/// Response model
struct ResponseModel {
    let statusCode : Int
    let error : Error?
    let data : NSDictionary?
    var success : Bool = false
}

struct ResponseDataModel {
    let statusCode : Int
    let error : Error?
    let data : Data?
    var success : Bool = false
}



