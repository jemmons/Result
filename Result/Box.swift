import Foundation

public class Box<T>{
  public let unbox:T
  public init(_ value:T){
    self.unbox = value
  }
}
