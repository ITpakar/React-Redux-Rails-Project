import actionTypes from '../constants';


export function starDeal(deal_id, user_id, url) {
  return function(dispatch) {
    $.ajax({
      url: url,
      method: 'POST',
      data: data
    }).done(function(response) {
      console.log(response);
      dispatch({
        type: actionTypes.DEALS.ADD_STARRED,
        payload: {
          id: response.id,
          title: response.title,
          url: response.url
        }
      })
    })
  }
}
