import ReactOnRails from 'react-on-rails';
import Provider from 'redux'

import createStore from '../store/doxlyStore';

// Components
import DealView from '../components/DealView';
import CreateDealModal from '../components/CreateDealModal';
import ProgressPieChart from '../components/ProgressPieChart';
import CommentBox from './CommentBox';
import DealStar from '../components/DealStar';

var store = createStore({});

ReactOnRails.register({DealView, 
                       CreateDealModal, 
                       ProgressPieChart, 
                       CommentBox,
                       DealStar});
