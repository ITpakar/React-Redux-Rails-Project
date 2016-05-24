import ReactOnRails from 'react-on-rails';
import Provider from 'redux'
import SignInForm from '../components/SignInForm';
import createStore from '../store/doxlyStore';

var store = createStore({});

ReactOnRails.register({SignInForm});
