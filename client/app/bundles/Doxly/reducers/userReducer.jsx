import actionTypes from '../constants/';

export const initialState = {
  user_id: null // this is the default state that would be used if one were not passed into the store
};

export default function userReducer(state = initialState, action) {
  const {type, payload} = action

  switch(type) {
    case actionTypes.USERS.LOGIN:
      return '';
    default:
      return state;
  }
}
