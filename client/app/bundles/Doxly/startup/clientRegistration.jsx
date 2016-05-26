import ReactOnRails from 'react-on-rails';
import Provider from 'redux'
import createStore from '../store/doxlyStore';
import SignInForm from './SignInForm';
import CommentBox from './CommentBox';

var store = createStore({});

ReactOnRails.register({SignInForm, CommentBox});
