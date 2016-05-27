import actionTypes from '../constants';

export default {
  starDeal: function(deal_id, user_id, url) {
    let data = {
      starred_deal: {
        user_id: user_id,
        deal_id: deal_id
      }
    }

    $.ajax({
      url: url,
      method: 'POST',
      data: data
    }).done(function(response) {
      return {
        type: actionTypes.DEALS.ADD_STARRED,
        payload: {
          id: response.id,
          title: response.title,
          url: response.url
        }
      }
    }).fail(function() {
      console.log("Something went wrong when trying to star a deal");
    })
  }
}