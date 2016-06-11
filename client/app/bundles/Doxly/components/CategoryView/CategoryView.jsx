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
import NewDocumentModal from "./NewDocumentModal";
import CommentBox from "../CommentBox/CommentBox";
import _ from "lodash";

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
      showNewDocumentModal: false,
      showNewTaskModal: false,
      showNewSectionModal: false,
      parentElement: undefined
    }

    _.bindAll(this, ['handleButtonClick',
                     'handleSortChange',
                     "selectElement",
                     "openNewFolderModal",
                     "openNewTaskModal",
                     "openNewSectionModal",
                     "openNewDocumentModal",
                     "closeNewFolderModal",
                     "closeNewTaskModal",
                     "closeNewSectionModal",
                     "closeNewDocumentModal",
                     "getChildElementsOf"]);
  }

  componentDidMount() {
    $(this.refs.button).popover();
  }

  handleButtonClick(event) {
  }

  handleSortChange(event) {

  }

  handleSubmit(event) {
    event.prevenDefault();
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

  openNewDocumentModal(element) {
    this.setState({showNewDocumentModal: true, parentElement: element});
  }

  closeNewDocumentModal() {
    this.setState({showNewDocumentModal: false, parentElement: undefined});
  }

  openNewTaskModal(element) {
    this.setState({showNewTaskModal: true, parentElement: element});
  }

  closeNewTaskModal() {
    this.setState({showNewTaskModal: false, parentElement: undefined});
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

  getChildElementsOf(element, type) {
    var results = [];

    if (element && element.elements) {
      for (let i = 0; i < element.elements.length; i++) {
        let el = element.elements[i];
        if (el.type == type) {
          results.push(el)
        }

        results = _.union(results, this.getChildElementsOf(el, type));
      }
    }

    return results;
  }

  render() {
    var selectedElementDetails;
    var selectedElementComments;
    if (this.state.selectedElement) {
      selectedElementDetails = (
        <CategoryElementDetails element={this.state.selectedElement} />
      );
      selectedElementComments = (
        <CommentBox element={this.state.selectedElement} />
      );
    }

    var toolbarBoxOverlayActions = (
      <Popover id="create-new-element">
        <div className='popover-menu-deal'>
          <a href='#' onClick={this.openNewSectionModal}>New Section</a>
          <a href='#' onClick={this.openNewTaskModal.bind(this, undefined)}>New Task</a>
          <a href='#' onClick={this.openNewDocumentModal.bind(this, undefined)}>New File</a>
          <a href='#' onClick={this.openNewFolderModal.bind(this, undefined)}>New Folder</a>
        </div>
      </Popover>
    );

    var availableSections = [];
    var availableTasks = [];
    var availableFolders = [];
    var availableTasksAndFolders = [];
    var elements = this.props.elements;
    if (elements) {
      for (let i = 0; i < elements.length; i++) {
        let el = elements[i];
        if (el.type == "Section") {
          availableSections.push(el);
        } else if (el.type == "Task") {
          availableTasks.push(el);
        } else if (el.type == "Folder") {
          availableFolders.push(el);
        }

        availableSections = _.union(availableSections, this.getChildElementsOf(el, "Section"));
        availableTasks = _.union(availableTasks, this.getChildElementsOf(el, "Task"));
        availableFolders = _.union(availableFolders, this.getChildElementsOf(el, "Folder"));
      }

      availableTasksAndFolders = _.union(availableTasks, availableFolders)
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
              <form onSubmit={this.handleSubmit}>
                  <SearchInput handleChange={this.props.searchTree} />
                  <GroupedSelectInput options={[
                    {
                      heading: "Sort By",
                      options: ['Manual Sort'],
                      optionsForHeading: ['Manual Sort'],
                      initialSelected: 0,
                      onChange: this.handleSortChange
                    }
                  ]} />
                <OverlayTrigger trigger="click" rootClose placement="bottom" overlay={toolbarBoxOverlayActions}>
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
                                      selectedElement={this.state.selectedElement}
                                      updateTask={this.props.updateTask}
                                      openNewDocumentModal={this.openNewDocumentModal}
                                      openNewFolderModal={this.openNewFolderModal}
                                      openNewTaskModal={this.openNewTaskModal}
                                      openNewSectionModal={this.openNewSectionModal} />
                </div>
                <div className="content-deal-right">
                  {selectedElementDetails}
                  {selectedElementComments}
                </div>
              </div>
            </div>
          </div>

          <NewFolderModal parentElement={this.state.parentElement}
                          tasks={availableTasks}
                          createFolder={this.props.createFolder}
                          closeNewFolderModal={this.closeNewFolderModal}
                          showNewFolderModal={this.state.showNewFolderModal} />
          <NewTaskModal parentElement={this.state.parentElement}
                        assignees={this.props.collaborators}
                        sections={availableSections}
                        createTask={this.props.createTask}
                        closeNewTaskModal={this.closeNewTaskModal}
                        showNewTaskModal={this.state.showNewTaskModal} />
          <NewSectionModal createSection={this.props.createSection}
                           closeNewSectionModal={this.closeNewSectionModal}
                           showNewSectionModal={this.state.showNewSectionModal} />
          <NewDocumentModal parentElement={this.state.parentElement}
                            parents={availableTasksAndFolders}
                            createDocument={this.props.createDocument}
                            closeNewDocumentModal={this.closeNewDocumentModal}
                            showNewDocumentModal={this.state.showNewDocumentModal} />
        </div>
    )
  }
}
