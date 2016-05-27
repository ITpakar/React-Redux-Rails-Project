// import { compose, createStore, applyMiddleware, combineReducers } from 'redux';

// We will probably want to use redux-thunk once we have async, so I'm leaving this here for now
// https://github.com/gaearon/redux-thunk and http://redux.js.org/docs/advanced/AsyncActions.html
// import thunkMiddleware from 'redux-thunk';

// import loggerMiddleware from 'lib/middlewares/loggerMiddleware';

// import reducers from '../reducers';
// import { initialStates } from '../reducers';

// export default props => {
//   // This is how we get initial props Rails into redux.
//   console.log(props);
//   const { starred_deals } = props;
//   // const { } = initialStates;

//   const initialState = {
//   };

//   const reducer = combineReducers(reducers);
//   const composedStore = compose(
//     applyMiddleware(loggerMiddleware)
//   );
//   const storeCreator = composedStore(createStore);

//   const store = storeCreator(reducer, initialState);

//   console.log(store);

//   return store;
// };


import { combineReducers, applyMiddleware, createStore } from 'redux';
import loggerMiddleware from 'lib/middlewares/loggerMiddleware';

import reducers from '../reducers';

/*
 *  Export a function that takes the props and returns a Redux store
 *  This is used so that 2 components can have the same store.
 */
export default (props, railsContext) => {
  const combinedReducer = combineReducers(reducers);
  props.railsContext = railsContext;
  return applyMiddleware(loggerMiddleware)(createStore)(combinedReducer, props);
};