
import UIKit
import Alamofire
import SwiftyJSON

class EndpointRequest: Operation {
    
    var baseURLString = "http://podcast-backend.herokuapp.com/api/v1"
    
    // Specific endpoint request path should always start with a /
    var path = "/"
    
    var httpMethod: HTTPMethod = .get
    var encoding: ParameterEncoding = URLEncoding.default
    var queryParameters: [String:Any]?
    var bodyParameters: [String:Any]?
    var headers = [String:String]()
    var requiresAuthenticatedUser: Bool = true
    
    var success: ((EndpointRequest) -> ())?
    var failure: ((EndpointRequest) -> ())?
    
    var responseJSON: JSON?
    
    // The result from processing the response JSON in processResponseJSON function
    var processedResponseValue: Any?
    
    // Used to hold endpoint request in operation queue until we explicitly say it's finished
    private var _finished : Bool = false
    override var isFinished : Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        
        if isCancelled {
            isFinished = true
            return
        }

        let endpointRequest = request(urlString(), method: httpMethod, parameters: parameters(), encoding: encoding, headers: authorizedHeaders())
        
        endpointRequest.validate(statusCode: 200 ..< 300).responseData { (response: DataResponse<Data>) in
            
            if self.isCancelled {
                self.isFinished = true
                return
            }
            
            self.handleResponse(response: response)
            self.isFinished = true
        }
    }
    
    func handleResponse(response: DataResponse<Data>) {
        
        switch response.result {
            
            case .success(let data):
                
                responseJSON = JSON(data: data)
                
                // check if server returned success
                if responseJSON?["success"].boolValue == false {
                    failure?(self)
                    return
                }
                
                processResponseJSON(responseJSON!)
                success?(self)
            
            case .failure(let error):
                
                if let endpoint = response.request {
                    print(endpoint)
                }
                
                print(error.localizedDescription)
                
                if let responseData = response.data {
                    responseJSON = JSON(responseData)
                }
            
                failure?(self)
        }
    }
    
    
    // Override in subclass to handle response from server
    func processResponseJSON(_ json: JSON) {
        
    }
    
    func urlString() -> String {
        return baseURLString + path
    }
    
    func parameters() -> [String:Any] {
        
        var params = [String:Any]()
        
        if let localBodyParameters = bodyParameters {
            encoding = JSONEncoding.default
            params = localBodyParameters
        } else if let localQueryParameters = queryParameters {
            encoding = URLEncoding.default
            return localQueryParameters
        }
        
        return params
    }
    
    func authorizedHeaders() -> [String: String] {
        
        if requiresAuthenticatedUser {
            guard let sessionToken = System.currentSession?.sessionToken else { return headers }
            headers["Authorization"] = "Bearer \(sessionToken)"
        }
        
        return headers
    }
    
}
