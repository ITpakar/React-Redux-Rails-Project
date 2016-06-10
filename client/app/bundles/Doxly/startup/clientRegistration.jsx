import ReactOnRails from 'react-on-rails';
import Provider from 'redux'

import doxlyStore from '../store/doxlyStore';

// Public Facing Components
import DealView from '../components/DealView';
import CreateDealModal from '../components/CreateDealModal';
import EditDealModal from './EditDealModal';
import ProgressPieChart from '../components/ProgressPieChart';
import CommentBox from './CommentBox';
import DealStar from './DealStar';
import StarredDealList from './StarredDealList';
import ArchiveDealButton from '../components/ArchiveDealButton';
import DealApp from './DealApp';
import TeamMembersView from '../components/TeamMembers/TeamMembersView';

ReactOnRails.register({DealView,
                       CreateDealModal,
                       EditDealModal,
                       ProgressPieChart,
                       CommentBox,
                       DealStar,
                       StarredDealList,
                       ArchiveDealButton,
                       DealApp,
                   	   TeamMembersView});

ReactOnRails.registerStore({doxlyStore});
