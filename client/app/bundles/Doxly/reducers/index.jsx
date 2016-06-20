// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/HelloWorld/store/helloWorldStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.
import userReducer from './userReducer';
import commentReducer from './commentReducer';
import collaboratorReducer from './collaboratorReducer';
import dealsReducer from './dealsReducer';
import sectionsReducer from "./sectionsReducer";
import dealCollaboratorsReducer from "./dealCollaboratorsReducer";
import reportReducer from "./reportReducer";
import documentReducer from "./documentReducer";
import { initialState as userState } from './userReducer';

export default {
  userStore: userReducer,
  commentStore: commentReducer,
  collaboratorStore: collaboratorReducer,
  dealsStore: dealsReducer,
  sectionsStore: sectionsReducer,
  dealCollaboratorsStore: dealCollaboratorsReducer,
  reportStore: reportReducer,
  documentStore: documentReducer
};

export const initialStates = {
  userState
};
