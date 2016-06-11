import actionTypes from '../constants';

export const initialState ={
  status: undefined
}

export default function dealCollaboratorsReducer(state = initialState, action) {
  switch (action.type) {
    case actionTypes.REQUESTS.LOAD_DEAL_COLLABORATORS:
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

    default:
      return state;
  }
}
