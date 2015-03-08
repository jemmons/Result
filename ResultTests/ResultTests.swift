import UIKit
import XCTest
import Result

private let error = NSError(domain: "SomeDomain", code: -100, userInfo: nil)

class ResultTests: XCTestCase {
  let valueResult = Result.Value(Box("Some Value"))
  let errorResult = Result<String>.Error(error)
  
  
  func testInitializer(){
    let subject = Result("Thing")
    XCTAssertEqual(subject.value!, "Thing")
  }


  func testValueGetter(){
    XCTAssertNotNil(valueResult.value)
    XCTAssertEqual(valueResult.value!, "Some Value")
    XCTAssertNil(errorResult.value)
  }
  
  
  func testErrorGetter(){
    XCTAssertNotNil(errorResult.error)
    XCTAssertEqual(errorResult.error!, error)
    XCTAssertNil(valueResult.error)
  }
  
  
  func testMap(){
    func valueMap(value:String)->Int{
      XCTAssertEqual(value, "Some Value")
      return 42
    }
    
    func errorMap(_:String)->Int{
      XCTFail()
      return 666
    }
  
    let mappedValue = valueResult.map(valueMap)
    XCTAssertEqual(mappedValue.value!, 42)
    let topMappedValue = map(valueResult, valueMap)
    XCTAssertEqual(topMappedValue.value!, mappedValue.value!)
    
    let mappedError = errorResult.map(errorMap)
    XCTAssertEqual(mappedError.error!, error)
    let topMappedError = map(errorResult, errorMap)
    XCTAssertEqual(topMappedError.error!, mappedError.error!)
  }
  
  
  func testFlatMap(){
    func valueMap(value:String) -> Result<Int>{
      XCTAssertEqual(value, "Some Value")
      return Result(count(value))
    }

    func errorMap(_:String) -> Result<Int>{
      XCTFail()
      return Result(666)
    }

    let mappedValue = valueResult.fmap(valueMap)
    XCTAssertEqual(mappedValue.value!, 10)
    let topMappedValue = fmap(valueResult, valueMap)
    XCTAssertEqual(topMappedValue.value!, mappedValue.value!)
    
    let mappedError = errorResult.fmap(errorMap)
    XCTAssertEqual(mappedError.error!, error)
    let topMappedError = fmap(errorResult, errorMap)
    XCTAssertEqual(topMappedError.error!, mappedError.error!)
  }
}
