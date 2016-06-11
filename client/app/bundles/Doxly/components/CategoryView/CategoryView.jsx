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

    _.bindAll(this, ['handleSearchChange',
                     'handleButtonClick',
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
                     "createFolder",
                     "createDocument",
                     "getChildElementsOf"]);
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

  openNewDocumentModal(element) {
    this.setState({showNewDocumentModal: true, parentElement: element});
  }

  closeNewDocumentModal() {
    this.setState({showNewDocumentModal: false, parentElement: undefined});
  }

  createDocument(title, file, callback) {
    var parentElement = this.state.parentElement;
    var data = new FormData();
    data.append("document[file]", file);
    data.append("document[title]", title)
    data.append("document[deal_documents_attributes][0][documentable_id]", parentElement.id)
    data.append("document[deal_documents_attributes][0][documentable_type]", parentElement.type)

    this.props.createDocument(data, callback);
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
    if (element && element.elements) {
      return _.filter(element.elements, function(el) { return el.type == type});
    } else {
      return [];
    }
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
    var elements = this.props.elements;
    if (elements) {
      for (let i = 0; i < elements.length; i++) {
        let el = elements[i];
        if (el.type == "Section") {
          availableSections.push(el);
        }

        availableSections = _.union(availableSections, this.getChildElementsOf(el.elements, "Section"));
      }
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
                          createFolder={this.createFolder}
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
                            createDocument={this.createDocument}
                            closeNewDocumentModal={this.closeNewDocumentModal}
                            showNewDocumentModal={this.state.showNewDocumentModal} />
        </div>
    )
  }
}
