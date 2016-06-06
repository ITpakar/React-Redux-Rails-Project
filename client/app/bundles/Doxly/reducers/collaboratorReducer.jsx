import actionTypes from '../constants/';
import _ from 'lodash';

export const initialState = {
  collaborators: []
};

export default function collaboratorReducer(state = initialState, action) {
  const {type, payload} = action
  switch(type) {
    case actionTypes.COLLABORATORS.LOAD:
      {
		const {collaborators, ...otherFields} = state;
	  	return {collaborators: payload, ...otherFields};
	  }
	case actionTypes.COLLABORATORS.ADD:
	  {
		  const {collaborators, ...otherFields} = state;	
		  collaborators.push(payload);
		  return {collaborators, ...otherFields}; 
	  }
	case actionTypes.COLLABORATORS.REMOVE:
	  {
		  const {collaborators, ...otherFields} = state;
		  _.remove(collaborators, {
		  	id: payload.id
		  });
		  return {collaborators, ...otherFields}; 
	  }
    default:
      return state;
  }
}

export function setCollaborators(collaborators) {
  return {
	type: actionTypes.COLLABORATORS.LOAD,
	payload: collaborators
  }
}

export function addCollaborator(collaborator) {
	return {
		type: actionTypes.COLLABORATORS.ADD,
		payload: collaborator
	}
}

export function removeCollaborator(collaborator) {
	return {
		type: actionTypes.COLLABORATORS.REMOVE,
		payload: collaborator
	}
}