import actionTypes from '../constants';

export const initialState ={
  status: undefined,
  data: undefined
}

export default function sectionsReducer(state = initialState, action) {
  switch (action.type) {
    case actionTypes.REQUESTS.LOAD_SECTIONS:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING,
            data: undefined
          });
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
