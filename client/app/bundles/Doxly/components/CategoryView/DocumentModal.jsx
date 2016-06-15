import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';

export default class DocumentModal extends React.Component {
  constructor(props, context) {
    super(props, context);
    _.bindAll(this, ["saveDocument", "handleSubmit", "showDialog"]);
  }

  handleSubmit(event) {
    if (event) {
      event.preventDefault();
    }

    var title = $.trim($(this.refs.document_title).val());
    var file = this.refs.file.files[0];
    var documentable_type;
    var documentable_id;

    if (this.props.parentElement) {
      documentable_type = this.props.parentElement.type;
      documentable_id = this.props.parentElement.id;
    } else {
      let documentable = $.trim($(this.refs.parent_id).val());
      let tmp = documentable.split("-");

      documentable_type = tmp[0];
      documentable_id = tmp[1];
    }

    if (title && file && documentable_type, documentable_id) {
      this.saveDocument(title, file, documentable_type, documentable_id);
    }
  }

  saveDocument(title, file, documentable_type, documentable_id) {
    if (title && file && documentable_type && documentable_id) {
      var _this = this;
      var data = new FormData();
      data.append("document[file]", file);
      data.append("document[title]", title)
      data.append("document[deal_documents_attributes][0][documentable_type]", documentable_type);
      data.append("document[deal_documents_attributes][0][documentable_id]", documentable_id);

      this.props.saveDocument(data, function() {
        _this.props.closeDocumentModal();
      });
    }
  }

  showDialog() {
    $(this.refs.file).click();
  }

  render() {
    var element = this.props.element;
    var availableTasksAndFolders = [];
    if (!this.props.parentElement && this.props.parents) {
      let parentId;

      if (element && element.id && element.deal_documents && element.deal_documents.length > 0) {
        parentId = element.deal_documents[0].documentable_type + "" + element.deal_documents[0].documentable_id;
      }
      availableTasksAndFolders = (
        <div className="form-group optional">
          <label htmlFor="input-task-section">Add to Task or Folder</label>
          <select name="task" ref="parent_id" value={parentId} className="form-control show-tick">
            <option>Select a Task or Folder</option>
            {this.props.parents.map(function(el, i) {
              return (
                <option value={el.type + "-" + el.id} key={"task_or_folder_" + (i + 1)}>{el.type}: - {el.title}</option>
              )
            })}
          </select>
        </div>
      );
    }

    var modalTitle = element && element.id ? "Update Document" : "New Document";
    var documentTitle = element && element.id && element.title;
    var submitText = element && element.id ? "Update" : "Create"

  	return (
      <Modal show={this.props.showDocumentModal} onHide={this.props.closeDocumentModal} dialogClassName="new-question-modal">
        <Modal.Header closeButton>
          <Modal.Title>
            {modalTitle}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <form onSubmit={this.handleSubmit}>
            <div className="form-group">
              <label htmlFor="input-document-title">File Name</label>
              <input type="text" ref="document_title" required value={documentTitle} placeholder="Give your document a title" className="form-control" id="input-file-title" name="document_title" />
            </div>
            {availableTasksAndFolders}
            <div className="form-group">
              <label>Upload</label>
              <a className="file-input-wrapper btn btn-fileinput  file-inputs" onClick={this.showDialog}>
                <span><i className="icon-icon-uploadcloud"></i> Choose a File</span>
                <input style={{left: "-11008.5px", top: "18.4px"}} ref="file" className="file-inputs" name="file_name" title="<i class='icon-icon-uploadcloud'></i> Choose a File" data-filename-placement="inside" type="file" />
              </a>
            </div>
          </form>
        </Modal.Body>
        <Modal.Footer>
          <button type="button" className="btn btn-default pull-left" onClick={this.props.closeDocumentModal}>Cancel</button>
          <button type="button" className="btn btn-primary" onClick={this.handleSubmit}>{submitText}</button>
        </Modal.Footer>
      </Modal>
  	);
  }
}
