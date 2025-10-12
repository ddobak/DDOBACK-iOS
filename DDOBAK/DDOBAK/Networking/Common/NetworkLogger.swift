import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {
    let queue = DispatchQueue(label: "network.logger.ddobak")

    func requestDidResume(_ request: Request) {
        print("➡️ [REQ] \(request.description)")
        
        if let headers = request.request?.allHTTPHeaderFields {
            print("👳 [REQ Headers]: \(headers)")
        }
        
        if let bodyData = request.request?.httpBody,
           let body = bodyData.prettyJson {
            print("🏋️ [REQ Body]: \(body)")
        }
        
        print("===================================================================================\n")
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let status = response.response?.statusCode ?? -1
        print("⬅️ [RES] status: \(status), for: \(request.description)")
        
        if let data = response.data, let body = data.prettyJson {
            print("👌 [RES Body]: \(body)")
        }
        
        if let error = response.error {
            print("🚨 [RES Error]: \(error.localizedDescription)")
        }
        
        print("===================================================================================\n")
    }
}
