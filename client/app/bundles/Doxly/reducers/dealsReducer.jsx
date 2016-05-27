import actionTypes from '../constants';

export const initialState ={
  starred: []
}

export default function dealsReducer(state = initialState, action) {
  const {type, payload} = action;

  switch (type) {
    default:
      return state;
  }
}