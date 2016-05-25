import ReactOnRails from 'react-on-rails';
import Provider from 'redux'
import SignInForm from '../components/SignInForm';
import DealView from '../components/DealView'
import createStore from '../store/doxlyStore';

var store = createStore({});

ReactOnRails.register({SignInForm});
ReactOnRails.register({DealView});
