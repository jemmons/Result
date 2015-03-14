import Foundation

public func map<T, U>(source:Result<T>, @noescape transform:(T)->U) -> Result<U>{
  switch source{
  case .Error(let error):
    return Result<U>.Error(error)
  case .Value(let box):
    return Result<U>.Value(Box(transform(box.unbox)))
  }
}


//A wrapper to work-around the fact you can't disambiguate a function in a method of the same name when inside a type with the same name as the module.
public func mapAlias<T, U>(source:Result<T>, transform:(T)->U) -> Result<U>{
  return map(source, transform)
}


public func flatten<T>(source:Result<Result<T>>)->Result<T>{
  switch source{
  case .Error(let error):
    return .Error(error)
  case .Value(let box):
    return box.unbox
  }
}


public func flatMap<T,U>(source:Result<T>, @noescape transform:(T)->Result<U>) -> Result<U>{
  return flatten(map(source, transform))
}


//A wrapper to work-around the fact you can't disambiguate a function in a method of the same name when inside a type with the same name as the module.
public func flatMapAlias<T,U>(result:Result<T>, f:(T)->Result<U>) -> Result<U>{
  return flatMap(result, f)
}


public enum Result<T>{
  case Value(Box<T>)
  case Error(NSError)
  
  public init(_ value:T){
    self = .Value(Box(value))
  }
}



public extension Result{
  var value:T?{
    switch self{
    case .Value(let box):
      return box.unbox
    case .Error:
      return nil
    }
  }
  
  
  var error:NSError?{
    switch self{
    case .Value:
      return nil
    case .Error(let error):
      return error
    }
  }
  
  
  func map<U>(f:(T)->U) -> Result<U>{
    return mapAlias(self, f)
  }
  
  
  func flatMap<U>(f:(T)->Result<U>)->Result<U>{
    return flatMapAlias(self, f)
  }
}
