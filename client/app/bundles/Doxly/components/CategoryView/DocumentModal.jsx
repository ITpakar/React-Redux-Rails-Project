import React, { PropTypes } from 'react';
import { Modal } from 'react-bootstrap';
import ReactDOM from "react-dom";
import Select from 'react-bootstrap-select';

export default class DocumentModal extends React.Component {
  constructor(props, context) {
    super(props, context);

    this.state = {
      signable: false,
      signerCount: 1,
      signers: []
    }
    _.bindAll(this, ["saveDocument", "handleSubmit", "showDialog", 'handleCheck', 'addSigner', 'handleSignerInputChange']);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.element && nextProps.element.signers_count > 0) {
      var state = {
        signable: true,
        signerCount: nextProps.element.signers_count,
        signers: nextProps.element.signers
      }
    } else {
      var state = {
        signable: false,
        signerCount: 1,
        signers: []
      }
    }

    this.setState(state);

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
      let documentable = $.trim($(ReactDOM.findDOMNode(this.refs.parent_id)).find("select").val());
      let tmp = documentable.split("-");

      documentable_type = tmp[0];
      documentable_id = tmp[1];
    }

    let signers = this.state.signable ? this.state.signers : []

    if (title && file && documentable_type && documentable_id) {
      this.saveDocument(title, file, documentable_type, documentable_id, signers);
    }
  }

  handleCheck(e) {
    this.setState({signable: !this.state.signable});
  }

  handleSignerInputChange(index, key) {
    var _this = this;

    return function(e) {
      let signers = _this.state.signers

      if (signers[index] === undefined) {
        signers[index] = {name:'', email: ''}
      }

      signers[index][key] = e.target.value

      _this.setState({signers: signers})
    }
  }

  saveDocument(title, file, documentable_type, documentable_id, signers) {
    if (title && file && documentable_type && documentable_id) {
      var _this = this;
      var data = new FormData();
      var element = this.props.element;

      data.append("document[file]", file);
      data.append("document[title]", title)
      data.append("document[deal_documents_attributes][0][documentable_type]", documentable_type);
      data.append("document[deal_documents_attributes][0][documentable_id]", documentable_id);

      _.forEach(signers, function(val, i) {
        data.append(`document[signers][${i}][name]`, val['name']);
        data.append(`document[signers][${i}][email]`, val['email']);
      });


      if (element && element.id) {
        this.props.updateDocument(element.id, data, function() {
          _this.props.closeDocumentModal();
        });
      } else {
        this.props.createDocument(data, function() {
          _this.props.closeDocumentModal();
        });
      }
    }
  }

  showDialog() {
    $(this.refs.file).click();
  }

  addSigner(e) {
    this.setState({signerCount: this.state.signerCount + 1});
  }

  getSignerValue(i, key) {
    if (this.state.signers && this.state.signers[i]) {
      return this.state.signers[i][key];
    }
    return null;
  }

  renderSignatoriesInput() {
    var signerInputs = [];

    for (var i = 0; i < this.state.signerCount; i++) {
      signerInputs.push(<input type="text" value={this.getSignerValue(i, 'name')} key={`signer[${i}][name]`} onChange={this.handleSignerInputChange(i, 'name')} className="form-control" placeholder="Enter Name" />)
      signerInputs.push(<input type="email" value={this.getSignerValue(i, 'email')} key={`signer[${i}][email]`} onChange={this.handleSignerInputChange(i, 'email')} className="form-control" placeholder="Enter Email" />)
    }

    if (this.state.signable) {
      return (
        <div className="form-group signer-inputs">
          <label>Add Signatories</label>
          {signerInputs}
          <button type="button" className="btn btn-default pull-left" onClick={this.addSigner}>Add another signer</button>
        </div>
      );
    }
  }

  render() {
    var element = this.props.element;
    var availableTasksAndFolders = [];
    if (!this.props.parentElement && this.props.parents) {
      let parentId;

      if (element && element.id && element.deal_documents && element.deal_documents.length > 0) {
        parentId = element.deal_documents[0].documentable_type + "-" + element.deal_documents[0].documentable_id;
      }
      availableTasksAndFolders = (
        <div className="form-group optional">
          <label htmlFor="input-task-section">Add to Task or Folder</label>
          <Select name="task" ref="parent_id" defaultValue={parentId} className="show-tick">
            <option>Select a Task or Folder</option>
            {this.props.parents.map(function(el, i) {
              return (
                <option value={el.type + "-" + el.id} key={"task_or_folder_" + (i + 1)}>{el.type}: - {el.title}</option>
              )
            })}
          </Select>
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
              <input type="text" ref="document_title" required defaultValue={documentTitle} placeholder="Give your document a title" className="form-control" id="input-file-title" name="document_title" />
            </div>
            {availableTasksAndFolders}
            <div className="form-group">
              <input type="checkbox" id="signable" value="signable" checked={this.state.signable} onClick={this.handleCheck} style={{margin: 0}}/> <label>Signable</label>
            </div>
            {this.renderSignatoriesInput()}
            <div className="form-group file-input-group">
              <label>Upload</label>
              <a className="file-input-wrapper btn btn-fileinput file-inputs" onClick={this.showDialog}>
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
