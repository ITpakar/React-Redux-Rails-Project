import React, { PropTypes } from 'react';
import { Popover, OverlayTrigger } from 'react-bootstrap';
import CategoryProgress from './CategoryProgress';
import SearchInput from '../SearchInput';
import GroupedSelectInput from '../GroupedSelectInput';
import CategoryFileViewer from './CategoryFileViewer'
import CategoryElementDetails from "./CategoryElementDetails";
import NewFolderModal from "./NewFolderModal";
import NewTaskModal from "./NewTaskModal";
import NewSectionModal from "./NewSectionModal";

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
      },
      selectedElement: undefined,
      showNewFolderModal: false,
      showNewFileModal: false,
      showNewTaskModal: false,
      showNewSectionModal: false,
      parentElement: undefined
    }

    _.bindAll(this, ['handleSearchChange',
                     'handleButtonClick',
                     'handleSortChange',
                     "selectElement",
                     "openNewFolderModal",
                     "openNewTaskModal",
                     "openNewSectionModal",
                     "closeNewFolderModal",
                     "closeNewTaskModal",
                     "closeNewSectionModal",
                     "createFolder",
                     "createTask"]);
  }

  componentDidMount() {
    $(this.refs.button).popover();
  }

  handleSearchChange(event) {
  }

  handleButtonClick(event) {
  }

  handleSortChange(event) {

  }

  selectElement(element) {
    this.setState({selectedElement: element});
  }

  openNewFolderModal(element) {
    this.setState({showNewFolderModal: true, parentElement: element});
  }

  closeNewFolderModal() {
    this.setState({showNewFolderModal: false, parentElement: undefined});
  }

  createFolder(folderAttrs, callback) {
    var parentElement = this.state.parentElement;
    folderAttrs.task_id = parentElement.id;

    this.props.createFolder(folderAttrs, callback);
  }

  openNewFileModal(element) {
    this.setState({showNewFileModal: true, parentElement: element});
  }

  closeNewFileModal() {
    this.setState({showNewFileModal: false, parentElement: undefined});
  }

  createFile(fileAttrs, callback) {
    var parentElement = this.state.parentElement;
    fileAttrs.task_id = parentElement.id;

    this.props.createFile(folderAttrs, callback);
  }

  openNewTaskModal(element) {
    this.setState({showNewTaskModal: true, parentElement: element});
  }

  closeNewTaskModal() {
    this.setState({showNewTaskModal: false, parentElement: undefined});
  }

  createTask(taskAttrs, callback) {
    var parentElement = this.state.parentElement;
    taskAttrs.section_id = parentElement.id;

    this.props.createTask(taskAttrs, callback);
  }

  openNewSectionModal() {
    this.setState({showNewSectionModal: true});
  }

  closeNewSectionModal() {
    this.setState({showNewSectionModal: false});
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
    var selectedElementDetails;
    if (this.state.selectedElement) {
      selectedElementDetails = (
        <CategoryElementDetails element={this.state.selectedElement} />
      );
    }

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
                  <OverlayTrigger trigger="click" rootClose placement="bottom" overlay={<Popover id="create-new-element"><div className='popover-menu-deal'><a href='#' data-target='#modal-new-section' data-toggle='modal'>New Section</a><a href='#' data-target='#modal-new-task' data-toggle='modal'>New Task</a><a href='#' data-target='#modal-new-file' data-toggle='modal'>New File</a><a href='#' data-target='#modal-new-folder' data-toggle='modal'>New Folder</a></div></Popover>}>
                    <a href="#" ref="button" className="btn-add-circle btn-add-deal"></a>
                  </OverlayTrigger>
              </form>
            </div>
          </div>

          <div className="row">
            <div className="content-deal">
              <div className="content-deal-wrapper">
                <div className="content-deal-left">
                  <CategoryFileViewer elements={this.props.elements}
                                      selectElement={this.selectElement}
                                      openNewFileModal={this.openNewFileModal}
                                      openNewFolderModal={this.openNewFolderModal}
                                      openNewTaskModal={this.openNewTaskModal}
                                      openNewSectionModal={this.openNewSectionModal} />
                </div>
                <div className="content-deal-right">
                  {selectedElementDetails}
                </div>
              </div>
            </div>
          </div>

          <NewFolderModal createFolder={this.createFolder}
                          closeNewFolderModal={this.closeNewFolderModal}
                          showNewFolderModal={this.state.showNewFolderModal} />
          <NewTaskModal createTask={this.createTask}
                        closeNewTaskModal={this.closeNewTaskModal}
                        showNewTaskModal={this.state.showNewTaskModal} />
                      <NewSectionModal createSection={this.props.createSection}
                           closeNewSectionModal={this.closeNewSectionModal}
                           showNewSectionModal={this.state.showNewSectionModal} />
        </div>
    )
  }
}
