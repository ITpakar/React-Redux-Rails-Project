import actionTypes from '../constants';
import {doLoadCategorySectionsTree} from "../utils/api";

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
    console.log("Line 43 ", cat);
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
