import React, { PropTypes } from 'react';
import { Popover, OverlayTrigger } from 'react-bootstrap';
import CategoryProgress from './CategoryProgress';
import SearchInput from '../SearchInput';
import GroupedSelectInput from '../GroupedSelectInput';
import CategoryFileViewer from './CategoryFileViewer'
import CategoryElementDetails from "./CategoryElementDetails";
import FolderModal from "./FolderModal";
import TaskModal from "./TaskModal";
import SectionModal from "./SectionModal";
import DocumentModal from "./DocumentModal";
import CommentBox from "../CommentBox/CommentBox";
import ConfirmModal from "../ConfirmModal";
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
      showFolderModal: false,
      showDocumentModal: false,
      showTaskModal: false,
      showSectionModal: false,
      showConfirmModal: false,
      parentElement: undefined,
      element: undefined
    }

    _.bindAll(this, ['handleSortChange',
                     "selectElement",
                     "openFolderModal",
                     "openTaskModal",
                     "openSectionModal",
                     "openDocumentModal",
                     "openConfirmModal",
                     "closeFolderModal",
                     "closeTaskModal",
                     "closeSectionModal",
                     "closeDocumentModal",
                     "closeConfirmModal",
                     "editElement",
                     "getChildElementsOf",
                     "doConfirm",
                     "dontConfirm",
                     "flattenElements"]);
  }

  componentDidMount() {
    $(this.refs.button).popover();
  }

  componentWillReceiveProps(newProps) {
    var selectedElement = this.state.selectedElement;
    var newElements = newProps.elements;

    if (newElements && selectedElement) {
      let flattenedElements = this.flattenElements(newElements);
      let updatedElement = _.find(flattenedElements, function(element) {
        return element.type == selectedElement.type && element.id == selectedElement.id;
      });

      if (updatedElement) {
        this.setState({selectedElement: updatedElement});
      } else {
        this.setState({selectedElement: undefined});
      }
    }
  }

  // TODO: Move to a util file
  flattenElements(elements) {
    if (!elements) {
      return [];
    }

    var results = [];
    for (let i = 0; i < elements.length; i++) {
      let el = elements[i];
      results.push(el);
      results = _.union(results, this.flattenElements(el.elements))
    }

    return results;
  }

  handleSortChange(event) {

  }

  handleSubmit(event) {
    event.prevenDefault();
  }

  selectElement(element) {
    this.setState({selectedElement: element});
  }

  openFolderModal(parentElement, element) {
    this.setState({showFolderModal: true, parentElement: parentElement, element: element});
  }

  closeFolderModal() {
    console.log("Line 118 ");
    this.setState({showFolderModal: false, parentElement: undefined});
  }

  openDocumentModal(parentElement, element) {
    this.setState({showDocumentModal: true, parentElement: parentElement, element: element});
  }

  closeDocumentModal() {
    this.setState({showDocumentModal: false, parentElement: undefined});
  }

  openTaskModal(parentElement, element) {
    this.setState({showTaskModal: true, parentElement: parentElement, element: element});
  }

  closeTaskModal() {
    this.setState({showTaskModal: false, parentElement: undefined});
  }

  openSectionModal(element) {
    this.setState({showSectionModal: true, element: element});
  }

  closeSectionModal() {
    this.setState({showSectionModal: false});
  }

  openConfirmModal() {
    this.setState({showConfirmModal: true});
  }

  closeConfirmModal() {
    this.setState({showConfirmModal: false, confirmElement: undefined});
  }

  editElement(element) {
    if (element.type == "Task") {
      this.openTaskModal(undefined, element);
    } else if (element.type == "Folder") {
      this.openFolderModal(undefined, element);
    } else if (element.type == "Document") {
      this.openDocumentModal(undefined, element);
    }
  }

  doConfirm() {
    var elementId = this.state.selectedElement.id;
    var elementType = this.state.selectedElement.type;
    this.closeConfirmModal();

    if (elementType == "Section") {
      this.props.deleteSection(elementId);
    } else if (elementType == "Task") {
      this.props.deleteTask(elementId);
    } else if (elementType == "Folder") {
      this.props.deleteFolder(elementId);
    } else if (elementType == "Document") {
      this.props.deleteDocument(elementId);
    }
  }

  dontConfirm() {
    this.closeConfirmModal();
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
        <CategoryElementDetails element={this.state.selectedElement} editElement={this.editElement} deleteElement={this.openConfirmModal} />
      );
      selectedElementComments = (
        <CommentBox user_id={this.props.user_id} element={this.state.selectedElement} deal_id={this.props.deal_id} />
      );
    }

    var toolbarBoxOverlayActions = (
      <Popover id="create-new-element">
        <div className='popover-menu-deal'>
          <a href='#' onClick={this.openSectionModal.bind(this, undefined)}>New Section</a>
          <a href='#' onClick={this.openTaskModal.bind(this, undefined, undefined)}>New Task</a>
          <a href='#' onClick={this.openDocumentModal.bind(this, undefined, undefined)}>New File</a>
          <a href='#' onClick={this.openFolderModal.bind(this, undefined, undefined)}>New Folder</a>
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

    let tasks = _.flatten(_.map(this.props.elements, function(e) {
      return e.elements;
    }))

    let completedTasks = _.reject(tasks, function(task) {
      return task.status != "Complete";
    })

    return (
        <div className="container-fluid">
          <div className="row">
              <CategoryProgress title={this.props.title}
                                totalCount={tasks.length}
                                completedCount={completedTasks.length} />
          </div>

          <div className="row">
            <div className="toolbar-box">
              <form onSubmit={this.handleSubmit}>
                  <SearchInput handleChange={this.props.searchTree} placeholder="Search Sections, Tasks, Folders and Files"/>
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
                                      openDocumentModal={this.openDocumentModal}
                                      openFolderModal={this.openFolderModal}
                                      openTaskModal={this.openTaskModal}
                                      openSectionModal={this.openSectionModal} />
                </div>
                <div className="content-deal-right">
                  {selectedElementDetails}
                  {selectedElementComments}
                </div>
              </div>
            </div>
          </div>

          <FolderModal parentElement={this.state.parentElement}
                       element={this.state.element}
                          tasks={availableTasks}
                          createFolder={this.props.createFolder}
                          updateFolder={this.props.updateFolder}
                          closeFolderModal={this.closeFolderModal}
                          showFolderModal={this.state.showFolderModal} />
          <TaskModal parentElement={this.state.parentElement}
                        element={this.state.element}
                        assignees={this.props.collaborators}
                        sections={availableSections}
                        createTask={this.props.createTask}
                        updateTask={this.props.updateTask}
                        closeTaskModal={this.closeTaskModal}
                        showTaskModal={this.state.showTaskModal} />
                      <SectionModal saveSection={this.props.saveSection}
                           closeSectionModal={this.closeSectionModal}
                           showSectionModal={this.state.showSectionModal} />
          <DocumentModal parentElement={this.state.parentElement}
                         element={this.state.element}
                            parents={availableTasksAndFolders}
                            createDocument={this.props.createDocument}
                            updateDocument={this.props.updateDocument}
                            closeDocumentModal={this.closeDocumentModal}
                            showDocumentModal={this.state.showDocumentModal} />
                          <ConfirmModal showConfirmModal={this.state.showConfirmModal}
                                        closeConfirmModal={this.closeConfirmModal}
                                        doConfirm={this.doConfirm}
                                        dontConfirm={this.dontConfirm} />
        </div>
    )
  }
}
