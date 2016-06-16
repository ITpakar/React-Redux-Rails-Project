import actionTypes from '../constants';

export default function dealsReducer(state = {}, action) {
  const {type, payload} = action;

  switch (action.type) {
    case actionTypes.REQUESTS.LOAD_DOCUMENT:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING
          });
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            data: action.data
          });
        default:
          return state;
      }
    case actionTypes.REQUESTS.CREATE_VERSION:
      switch (action.status) {
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            data: action.data
          });
        default:
          return state;
      }
    default:
      return state;
  }
}
