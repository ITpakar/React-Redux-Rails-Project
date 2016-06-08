import React, { PropTypes } from 'react';
import Popover from '@terebentina/react-popover';
import CategoryProgress from './CategoryProgress';
import SearchInput from '../SearchInput';

// Props
// title

// Can be calculated
// totalCount
// completedCount

export default class CategoryView extends React.Component {

  componentDidMount() {

  }

  handleSearchChange(event) {

  }

  handleButtonClick(event) {

  }



  render() {
    console.log("Popover");
    console.log(Popover);
    return (
        <div className="container-fluid">
          <div className="row">
              <CategoryProgress title={this.props.title}
                                totalCount={100}
                                completedCount={100} />
          </div>

          <div className="row">
            <div className="toolbar-box">
              <form>
                  <SearchInput onChange={this.handleSearchChange}/>

                  <Popover position="bottom" className="awesome" trigger={<a href="#" className="btn-add-circle btn-add-deal"></a>}>
                    <div className="popover-content">
                    <div className='popover-menu-deal'>
                      <a href='#' data-target='#modal-new-section' data-toggle='modal'>New Section</a>
                      <a href='#' data-target='#modal-new-task' data-toggle='modal'>New Task</a>
                      <a href='#' data-target='#modal-new-file' data-toggle='modal'>New File</a>
                      <a href='#' data-target='#modal-new-folder' data-toggle='modal'>New Folder</a>
                    </div>
                  </div>
                  </Popover>
                  
              </form>
            </div>
          </div>

        </div>
    )
  }
}