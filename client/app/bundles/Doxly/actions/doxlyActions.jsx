import actionTypes from '../constants';
import {doLoadCategorySectionsTree, doLoadDealCollaborators} from "../utils/api";
import {doLoadDealsByType, doLoadDealsByMember, doLoadDealsBySize} from "../utils/api";
import {doLoadDocument, doCreateVersion} from "../utils/api";

export function starDeal(id, title, url) {

  return {
    type: actionTypes.DEALS.ADD_STARRED,
    payload: {
      id: id,
      title: title,
      url: url
    }
  }

}

export function unstarDeal(id, title, url) {
  return {
    type: actionTypes.DEALS.REMOVE_STARRED,
    payload: {
      id: id,
      title: title,
      url: url
    }
  }
}

let setRequestStatus = function(requestType, status, data, responseStatus) {
  return {
    type: requestType,
    status,
    data,
    responseStatus
  };
};

export function loadCategorySectionsTree(dealId, category) {
  var requestType;
  var categoryId;
  if (category) {
    var cat = category.name.toLowerCase();
    categoryId = category.id;

    if (cat == "diligencecategory") {
      requestType = actionTypes.REQUESTS.LOAD_DILIGENCE_SECTIONS;
    } else if (cat == "closingcategory"){
      requestType = actionTypes.REQUESTS.LOAD_CLOSING_SECTIONS;
    } else {
      requestType = actionTypes.REQUESTS.LOAD_SECTIONS;
    }
  } else {
    requestType = actionTypes.REQUESTS.LOAD_SECTIONS;
  }

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doLoadCategorySectionsTree(dealId, categoryId).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}

export function loadDealCollaborators(dealId) {
  var requestType = actionTypes.REQUESTS.LOAD_DEAL_COLLABORATORS;

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doLoadDealCollaborators(dealId).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}

export function updateTask(taskId, attrs) {
  var requestType = actionTypes.REQUESTS.UPDATE_TASK;

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doUpdateTask(dealId, attrs).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}

export function loadDealsByType(period) {
  var requestType = actionTypes.REQUESTS.LOAD_DEALS_BY_TYPE;

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doLoadDealsByType(period).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}

export function loadDocument(documentId) {
  var requestType = actionTypes.REQUESTS.LOAD_DOCUMENT;

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doLoadDocument(documentId).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}

export function loadDealsByMember(period) {
  var requestType = actionTypes.REQUESTS.LOAD_DEALS_BY_MEMBER;

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doLoadDealsByMember(period).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}

export function loadDealsBySize(period) {
  var requestType = actionTypes.REQUESTS.LOAD_DEALS_BY_SIZE;

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doLoadDealsBySize(period).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}

export function createVersion(documentId, formData) {
  var requestType = actionTypes.REQUESTS.CREATE_VERSION;

  return function(dispatch) {
    dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.LOADING));
    return doCreateVersion(documentId, formData).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(requestType, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}
