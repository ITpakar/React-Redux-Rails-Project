import actionTypes from '../constants';

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
