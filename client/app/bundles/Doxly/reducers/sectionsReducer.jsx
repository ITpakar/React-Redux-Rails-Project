import actionTypes from '../constants';

export const initialState ={
  status: undefined
}

export default function sectionsReducer(state = initialState, action) {
  console.log("Line 9 ", state);
  switch (action.type) {
    case actionTypes.REQUESTS.LOAD_SECTIONS:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING
          });
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            allSections: action.data
          });
        default:
          return state;
      }

    case actionTypes.REQUESTS.LOAD_DILIGENCE_SECTIONS:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING
          });
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            diligenceSections: action.data
          });
        default:
          return state;
      }
    case actionTypes.REQUESTS.LOAD_CLOSING_SECTIONS:
      switch (action.status) {
        case actionTypes.REQUESTS.LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.LOADING
          });
        case actionTypes.REQUESTS.FINISH_LOADING:
          return Object.assign({}, state, {
            status: actionTypes.REQUESTS.FINISH_LOADING,
            closingSections: action.data
          });
        default:
          return state;
      }
    default:
      return state;
  }
}
