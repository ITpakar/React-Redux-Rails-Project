let submitRequest = function(url, method, data, successCallback, errorCallback) {
  return $.ajax({
    url: url,
    type: method,
    data: data,
    success: function(respondData) {
      if (successCallback) {
        successCallback(respondData);
      }
    },
    error: function(xhr, code, status) {
      if (errorCallback) {
        errorCallback(xhr, code, status);
      }
    }
  });
}

export function doLoadCategorySectionsTree(section, dealId) {
  return submitRequest("/api/deals/" + dealId + "/sections/trees", "get", {category: section});
}
