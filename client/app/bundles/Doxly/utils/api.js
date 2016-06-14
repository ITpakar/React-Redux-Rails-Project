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

export function doCreateDocument(formData) {
  return $.ajax({
    url: '/api/documents?files',
    type: 'POST',
    data: formData,
    cache: false,
    dataType: 'json',
    processData: false, // Don't process the files
    contentType: false // Set content type to false as jQuery will tell the server its a query string request
    });
}

export function doLoadDealCollaborators(dealId) {
  return submitRequest("/api/deals/" + dealId + "/deal_collaborators", "get");
}

export function doUpdateTask(taskId, attrs) {
  return submitRequest("/api/tasks/" + taskId, "put", {task: attrs});
}

export function doLoadDealsByType(period) {
  return submitRequest("/api/deals/summary", "get", {time: period, by: "type"});
}

export function doLoadDealsByMember(period) {
  return submitRequest("/api/deals/summary", "get", {time: period, by: "member"});
}

export function doLoadDealsBySize(period) {
  return submitRequest("/api/deals/summary", "get", {time: period, by: "size"});
}
