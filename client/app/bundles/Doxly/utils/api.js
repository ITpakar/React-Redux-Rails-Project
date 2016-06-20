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


//**************  BEGIN CRUD Section/Task/Folder/Document   *********************/

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

export function doUpdateFolder(folderId, attrs) {
  return submitRequest("/api/folders/" + folderId, "put", {folder: attrs});
}

export function doUpdateTask(taskId, attrs) {
  return submitRequest("/api/tasks/" + taskId, "put", {task: attrs});
}

export function doUpdateSection(dealId, sectionId, attrs) {
  return submitRequest("/api/deals/" + dealId + "/sections/" + sectionId, "put", {section: attrs});
}

export function doUpdateDocument(documentId, formData) {
  return $.ajax({
    url: '/api/documents/' + documentId,
    type: 'PUT',
    data: formData,
    cache: false,
    dataType: 'json',
    processData: false, // Don't process the files
    contentType: false // Set content type to false as jQuery will tell the server its a query string request
  });
}

export function doDeleteFolder(folderId) {
  return submitRequest("/api/folders/" + folderId, "delete");
}

export function doDeleteTask(taskId) {
  return submitRequest("/api/tasks/" + taskId, "delete");
}

export function doDeleteSection(dealId, sectionId) {
  return submitRequest("/api/deals/" + dealId + "/sections/" + sectionId, "delete");
}

export function doDeleteDocument(documentId) {
  return submitRequest("/api/documents/" + documentId, "delete");
}
//**************  END CRUD Section/Task/Folder/Document   *********************/

export function doLoadDocument(documentId) {
  return submitRequest("/api/documents/" + documentId, "get");
}

export function doCreateVersion(documentId, formData) {
  return $.ajax({
    url: '/api/documents/' + documentId + "/versions",
    type: 'POST',
    data: formData,
    cache: false,
    dataType: 'json',
    processData: false,
    contentType: false
  });
}

export function doLoadDealCollaborators(dealId) {
  return submitRequest("/api/deals/" + dealId + "/deal_collaborators", "get");
}
