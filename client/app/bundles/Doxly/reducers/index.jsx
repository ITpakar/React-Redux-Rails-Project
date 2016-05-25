// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/HelloWorld/store/helloWorldStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.
import userReducer from './userReducer';
import commentReducer from './commentReducer';
import { initialState as userState } from './userReducer';

export default {
  userStore: userReducer,
  commentStore: commentReducer
};

export const initialStates = {
  userState
};
