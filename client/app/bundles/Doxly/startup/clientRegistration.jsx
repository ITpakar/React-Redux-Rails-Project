import ReactOnRails from 'react-on-rails';
import Provider from 'redux'

import doxlyStore from '../store/doxlyStore';

// Public Facing Components
import DealView from '../components/DealView';
import DealList from '../components/DealList';
import CreateDealModal from '../components/CreateDealModal';
import EditDealModal from './EditDealModal';
import ProgressPieChart from '../components/ProgressPieChart';
import CommentBox from './CommentBox';
import DealStar from './DealStar';
import StarredDealList from './StarredDealList';
import ArchiveDealButton from '../components/ArchiveDealButton';
import DealApp from './DealApp';
import ReportApp from './ReportApp';
import DocumentShowApp from './DocumentShowApp';
import TeamMembersView from '../components/TeamMembers/TeamMembersView';

ReactOnRails.register({DealView,
					   DealList,
                       CreateDealModal,
                       EditDealModal,
                       ProgressPieChart,
                       CommentBox,
                       DealStar,
                       StarredDealList,
                       ArchiveDealButton,
                       DealApp,
                       ReportApp,
                       DocumentShowApp,
                   	   TeamMembersView});

ReactOnRails.registerStore({doxlyStore});
