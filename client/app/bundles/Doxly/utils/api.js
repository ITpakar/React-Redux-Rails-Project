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

export function doLoadCategorySectionsTree(dealId, categoryId) {
  return submitRequest("/api/deals/" + dealId + "/sections/trees", "get", {category_id: categoryId});
}

export function doCreateFolder(attrs) {
  return submitRequest("/api/folders", "post", {folder: attrs});
}

export function doCreateTask(attrs) {
  return submitRequest("/api/tasks", "post", {task: attrs});
}

export function doCreateSection(dealId, attrs) {
  return submitRequest("/api/deals/" + dealId + "/sections", "post", {section: attrs});
}
