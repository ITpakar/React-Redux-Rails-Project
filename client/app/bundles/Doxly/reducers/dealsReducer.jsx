import actionTypes from '../constants';

export const initialState ={
  starred: []
}

export default function dealsReducer(state = initialState, action) {
  const {type, payload} = action;

  switch (type) {
    case actionTypes.DEALS.ADD_STARRED:
      return Object.assign({}, state, {
        starred: _.concat(state.starred, payload)
      });
    case actionTypes.DEALS.REMOVE_STARRED:
      return Object.assign({}, state, {
        starred: _.reject(state.starred, function(deal){return deal.id == payload.id})
      });
    default:
      return state;
  }
}