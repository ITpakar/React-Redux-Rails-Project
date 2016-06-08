import React, { PropTypes } from 'react';
import Popover from '@terebentina/react-popover';
import CategoryProgress from './CategoryProgress';
import SearchInput from '../SearchInput';
import GroupedSelectInput from '../GroupedSelectInput';

// Props
// title

// Can be calculated
// totalCount
// completedCount

export default class CategoryView extends React.Component {

  constructor(props, context) {
    super(props, context);

    this.state = {
      popoverVisible: false,
      position: {
        left: 0,
        top: 0
      }
    }

    _.bindAll(this, ['handleSearchChange', 'handleButtonClick', 'handleSortChange']);
  }

  componentDidMount() {

  }

  handleSearchChange(event) {
  }

  handleButtonClick(event) {
    let position = $(this.refs.button).position();
    let popoverWidth = $(this.refs.popover).width();
    console.log(popoverWidth);
    this.setState({popoverVisible: true, position: {left: position.left + 40 - popoverWidth, top: position.top + 40}});
  }

  handleSortChange(event) {

  }

  renderPopover() {
    console.log(this.state);
    if (this.state.popoverVisible) {
      return (
        <div ref="popover" className="popover fade bottom in" style={{display: 'block', position: 'absolute', top: this.state.position.top, left: this.state.position.left}}>
          <div className="arrow" style={{left: '80.198%'}}></div>
          <div className="popover-content">
            <div className='popover-menu-deal'>
              <a href='#' data-target='#modal-new-section' data-toggle='modal'>New Section</a>
              <a href='#' data-target='#modal-new-task' data-toggle='modal'>New Task</a>
              <a href='#' data-target='#modal-new-file' data-toggle='modal'>New File</a>
              <a href='#' data-target='#modal-new-folder' data-toggle='modal'>New Folder</a>
            </div>
          </div>
        </div>
      );
    }
  }

  render() {
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
                  <SearchInput onChange={this.handleSearchChange} />
                  <GroupedSelectInput options={[
                    {
                      heading: "Sort By", 
                      options: ['Manual Sort'],
                      optionsForHeading: ['Manual Sort'],
                      initialSelected: 0,
                      onChange: this.handleSortChange
                    }
                  ]} />
                  <a ref="button" href="#" className="btn-add-circle btn-add-deal" onClick={this.handleButtonClick}></a>
                  {this.renderPopover()}                  
              </form>
            </div>
          </div>

        </div>
    )
  }
}