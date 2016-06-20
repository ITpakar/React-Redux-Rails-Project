import actionTypes from '../constants';

export default function reportReducer(state = {}, action) {
  switch (action.type) {
    case actionTypes.REQUESTS.LOAD_DEALS_BY_TYPE:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING
          });
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            dealsByType: action.data
          });
        default:
          return state;
      }

    case actionTypes.REQUESTS.LOAD_DEALS_BY_MEMBER:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING
          });
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            dealsByMember: action.data
          });
        default:
          return state;
      }
    case actionTypes.REQUESTS.LOAD_DEALS_BY_SIZE:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING
          });
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            dealsBySize: action.data
          });
        default:
          return state;
      }
    default:
      return state;
  }
}
