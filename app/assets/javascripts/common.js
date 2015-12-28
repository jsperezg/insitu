var INSITU = INSITU || {};

INSITU.namespace = function (ns_string) {
  var parts = ns_string.split('.'),
      parent = INSITU,
      i, l;

  if(parts[0] === 'INSITU') {
    parts = parts.splice(1);
  }

  for (i = 0, l = parts.length; i < l; i += 1) {
    if (typeof parent[parts[i]] === 'undefined') {
      parent[parts[i]] = {};
    }

    parent = parent[parts[i]];
  }

  return parent;
};