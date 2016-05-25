import React from 'react';
import { Provider } from 'react-redux';

import createStore from '../store/doxlyStore';
import ChatBox from '../components/ChatBox';

// See documentation for https://github.com/reactjs/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
export default (props) => {
  const store = createStore(props);
  const reactComponent = (
  	<Provider store={store}>
      <ChatBox {...props}/>
    </Provider>
  );
  return reactComponent;
};