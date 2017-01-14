function defined (value) {
  return value !== undefined && value !== null;
}

function extend(child, parent) {
  var property;

  for (property in parent) {
    if (parent.hasOwnProperty(property)) {
      Object.defineProperty(child, property, Object.getOwnPropertyDescriptor(parent, property));
    } else {
      if (ko.isObservable(parent[property])) {
        child[property] = ko.observable(parent[property]());
      } else {
        // If the child has overrided the parent function do not override it again.
        if (typeof parent[property] === 'function' && child[property] === undefined) {
          child[property] = parent[property];
        }
      }
    }
  }
}