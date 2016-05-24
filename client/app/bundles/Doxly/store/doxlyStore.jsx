import { compose, createStore, applyMiddleware, combineReducers } from 'redux';

// We will probably want to use redux-thunk once we have async, so I'm leaving this here for now
// https://github.com/gaearon/redux-thunk and http://redux.js.org/docs/advanced/AsyncActions.html
// import thunkMiddleware from 'redux-thunk';

import loggerMiddleware from 'lib/middlewares/loggerMiddleware';

import reducers from '../reducers';
import { initialStates } from '../reducers';

export default props => {
  // This is how we get initial props Rails into redux.
  const { user_id } = props;
  const { userState } = initialStates;

  const initialState = {
    userStore: userState.merge({
      user_id
    }),
  };

  const reducer = combineReducers(reducers);
  const composedStore = compose(
    applyMiddleware(loggerMiddleware)
  );
  const storeCreator = composedStore(createStore);

  const store = storeCreator(reducer, initialState);

  return store;
};
