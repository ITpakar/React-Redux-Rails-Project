import actionTypes from '../constants/';

export const initialState = {
  user_id: null, // this is the default state that would be used if one were not passed into the store
  comments: []
};

export default function commentReducer(state = initialState, action) {
  const {type, payload} = action
  switch(type) {
    case actionTypes.COMMENTS.LOAD:
      {
		const {comments, ...otherFields} = state;
	  	return {comments: payload, ...otherFields};
	  }
	case actionTypes.COMMENTS.ADD:
	  {
		  const {comments, ...otherFields} = state;	
		  comments.push(payload);
		  return {comments, ...otherFields}; 
	  }
    default:
      return state;
  }
}

export function setComments(comments) {
	return {
		type: actionTypes.COMMENTS.LOAD,
		payload: comments
	}
}

export function addComment(comment) {
	return {
		type: actionTypes.COMMENTS.ADD,
		payload: comment
	}
}
