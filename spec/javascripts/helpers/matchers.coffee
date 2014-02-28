jasmine.addMatchers {
  toBePromise: (promise)->
    expect(angular.isFunction(promise.then)).toBe true
    expect(angular.isFunction(promise.success)).toBe true
    expect(angular.isFunction(promise.finally)).toBe true
    expect(angular.isFunction(promise.error)).toBe true
    expect(angular.isFunction(promise.catch)).toBe true
}
