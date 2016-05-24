import { compose, createStore, applyMiddleware, combineReducers } from 'redux';

// We will probably want to use redux-thunk once we have async, so I'm leaving this here for now
// https://github.com/gaearon/redux-thunk and http://redux.js.org/docs/advanced/AsyncActions.html
// import thunkMiddleware from 'redux-thunk';

import reducers from '../reducers';
import { initialStates } from '../reducers';

export default props => {
  // This is how we get initial props Rails into redux.
  const { name } = props;
  const { $$doxlyState } = initialStates;

  // Redux expects to initialize the store using an Object, not an Immutable.Map
  const initialState = {
    $$doxlyStore: $$doxlyState.merge({
      name,
    }),
  };

  const reducer = combineReducers(reducers);
  const store = createStore(reducer, initialState);

  return store;
};
