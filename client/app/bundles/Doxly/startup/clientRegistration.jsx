import ReactOnRails from 'react-on-rails';
import Provider from 'redux'

import doxlyStore from '../store/doxlyStore';

// Components
import DealView from '../components/DealView';
import CreateDealModal from '../components/CreateDealModal';
import ProgressPieChart from '../components/ProgressPieChart';
import CommentBox from './CommentBox';
import DealStar from './DealStar';
import StarredDealList from './StarredDealList';

ReactOnRails.setOptions({
     traceTurbolinks: true,
   });

ReactOnRails.register({DealView, 
                       CreateDealModal, 
                       ProgressPieChart, 
                       CommentBox,
                       DealStar,
                       StarredDealList});

ReactOnRails.registerStore({doxlyStore});
