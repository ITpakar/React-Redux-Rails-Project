import { combineReducers, applyMiddleware, createStore } from 'redux';
import loggerMiddleware from 'lib/middlewares/loggerMiddleware';
import thunkMiddleware from 'redux-thunk';

import reducers from '../reducers';

/*
 *  Export a function that takes the props and returns a Redux store
 *  This is used so that 2 components can have the same store.
 */
export default (props, railsContext) => {

  const { starred_deals } = props

  const initialState = {
    dealsStore: {
      starred: starred_deals
    }
  };

  const combinedReducer = combineReducers(reducers);
  props.railsContext = railsContext;
  return applyMiddleware(thunkMiddleware, loggerMiddleware)(createStore)(combinedReducer, initialState);
};