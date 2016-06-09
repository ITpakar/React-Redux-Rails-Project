import actionTypes from '../constants';
import {doLoadDealSectionsTree} from "../utils/api";

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

export function loadDealSectionsTree(dealId) {
  return function(dispatch) {
    dispatch(setRequestStatus(actionTypes.REQUESTS.LOAD_SECTIONS, actionTypes.REQUESTS.LOADING));
    return doLoadDealSectionsTree(dealId).then(function(responseData, responseStatus) {
      dispatch(setRequestStatus(actionTypes.REQUESTS.LOAD_SECTIONS, actionTypes.REQUESTS.FINISH_LOADING, responseData, responseStatus));
    }, function(xhr, responseStatus) {
      dispatch(setRequestStatus(actionTypes.REQUESTS.LOAD_SECTIONS, actionTypes.REQUESTS.FINISH_LOADING, xhr.responseJSON, responseStatus));
    })
  }
}
