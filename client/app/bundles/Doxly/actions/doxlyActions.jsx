import actionTypes from '../constants';

export default {
  login: function(data) {
    return {
      type: actionTypes.USERS.LOGIN,
      payload: {username: data['username'], password: data['password']}
    }
  }
}