import Foundation

public func map<T, U>(result:Result<T>, f:(T)->U) -> Result<U>{
  switch result{
  case .Error(let error):
    return Result<U>.Error(error)
  case .Value(let box):
    return Result<U>.Value(Box(f(box.unbox)))
  }
}


//A wrapper to work-around the fact you can't disambiguate a function in a method of the same name when inside a type with the same name as the module.
public func mapAlias<T, U>(result:Result<T>, f:(T)->U) -> Result<U>{
  return map(result, f)
}


public func flatten<T>(result:Result<Result<T>>)->Result<T>{
  switch result{
  case .Error(let error):
    return .Error(error)
  case .Value(let box):
    return box.unbox
  }
}


public func fmap<T,U>(result:Result<T>, f:(T)->Result<U>) -> Result<U>{
  return flatten(map(result, f))
}


//A wrapper to work-around the fact you can't disambiguate a function in a method of the same name when inside a type with the same name as the module.
public func fmapAlias<T,U>(result:Result<T>, f:(T)->Result<U>) -> Result<U>{
  return fmap(result, f)
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
  
  
  func fmap<U>(f:(T)->Result<U>)->Result<U>{
    return fmapAlias(self, f)
  }
}
