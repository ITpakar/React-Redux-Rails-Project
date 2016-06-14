import React, { PropTypes } from 'react';
import _ from "lodash";
import FileViewer from "./FileViewer";
import ChangesView from "./ChangesView";
import CommentBox from "../CommentBox/CommentBox";
import Util from "../../utils/util";

export default class DocumentHistoriesView extends React.Component {
  constructor(props, context) {
    super(props, context);
    this.state = {versionIndex: undefined};
    _.bindAll(this, ["changeVersion", "getSelectedIndex", "download"]);
  }

  changeVersion() {
    var val = $(this.refs.versionIndex).val();
    this.setState({versionIndex: val});
  }

  getSelectedIndex() {
    var versions = this.props.document.versions;
    var selectedIndex;

    if (this.state.versionIndex !== undefined && this.state.versionIndex !== null) {
      selectedIndex = this.state.versionIndex;
    } else if (this.props.defaultVersionIndex !== undefined && this.props.defaultVersionIndex !== null) {
      selectedIndex = this.props.defaultVersionIndex;
    } else {
      selectedIndex = versions.length - 1;
    }

    return selectedIndex;
  }

  download(event) {
    if (event) {
      event.preventDefault();
    }

    var versions = this.props.document.versions;
    var selectedIndex = this.getSelectedIndex();
    var docVersion = versions[selectedIndex];

    window.open(docVersion.url);
  }

  render() {
    var doc = this.props.document;
    var versions = doc.versions;
    if (!versions || versions.length == 0) {
      return (
        <div className="text-center">Loading...</div>
      );
    }

    var selectedIndex = this.getSelectedIndex();
    var docVersion = versions[selectedIndex];
    var versionOptions = [];

    for (let i = 0; i < versions.length; i++) {
      let v;

      if (i == selectedIndex) {
        v = (
          <option value={i} key={"option_" + (i + 1)}>{versions[i].title} (current)</option>
        );
      } else {
        v = (
          <option value={i} key={"option_" + (i + 1)}>{versions[i].title}</option>
        );
      }

      versionOptions.push(v);
    }

    var uploadedBy;
    if (docVersion.creator) {
      uploadedBy = (
        <span className="uploaded-by">
          by {docVersion.creator.first_name} {docVersion.creator.last_name}
        </span>
      );
    }
    return (
      <div id="page-wrapper">
        <div className="file-viewer__toolbox">
            <div className="toolbox-left">
                <a href="#" className="file-viewer__close"><i className="icon-icon-close"></i></a>
                <div className="file-viewer__title">
                    <div className="title">
                        {docVersion.title} <span className="badge-signed signed">FIXME: 3/3 signed</span>
                    </div>
                    <div className="meta">
                        V{selectedIndex + 1} Uploaded {Util.formatDate(docVersion.file_uploaded_at, "MM/DD/YYYY")} at {Util.formatDate(docVersion.file_uploaded_at, "HH:MM A")} {uploadedBy}
                    </div>
                </div>
                <div className="buttons">
                    <a href="#" className="btn btn-default">...</a>
                    <a href="#" className="btn btn-default" onClick={this.download}>Download</a>
                </div>
            </div>
            <div className="toolbox-right">
                <div className="chat-box" data-target="#chat-box-1">
                    <div className="chat-box-toggle">
                        <div className="btn-group">
                            <a className="btn toggle-active" href="#deal-chat-internal">Internal Chat</a>
                            <a className="btn" href="#deal-chat-external">External Chat</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div className="content-file-viewer">
            <div className="content-file-viewer-wrapper">
                <div className="content-file-viewer-left">
                    <div className="clearfix">
                        <div className="version-select">
                            <form>
                                <div className="form-group optional">
                                    <select name="file_vestion" ref="versionIndex" value={selectedIndex} className="form-control show-tick" onChange={this.changeVersion}>
                                        {versionOptions}
                                    </select>
                                </div>
                            </form>
                        </div>
                        <ul className="nav flat-button-tabs pull-right" role="tablist">
                            <li role="presentation" className="active"><a href="#tab-file-view" aria-controls="tab-file-view" role="tab" data-toggle="tab">Document View</a></li>
                            <li role="presentation"><a href="#tab-file-changes" aria-controls="tab-file-changes" role="tab" data-toggle="tab">Changes View</a></li>
                        </ul>
                    </div>
                    <div className="tab-content">
                        <div role="tabpanel" className="tab-pane active" id="tab-file-view">
                            <div className="container-fluid">
                                <div className="row">
                                    <FileViewer url={docVersion.url} />
                                </div>
                            </div>
                        </div>
                        <div role="tabpanel" className="tab-pane" id="tab-file-changes">
                            <div className="container-fluid">
                                <div className="row">
                                    <div className="content-document">
                                        <ChangesView changes={docVersion.changes} />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="content-file-viewer-right">
                    <div className="chat-box chat-box-small" id="chat-box-1">
                        <div className="chat-box-details">
                            <div className="chat-box-details__instance internal toggle-active" id="deal-chat-internal">
                              <CommentBox />
                            </div>

                            <div className="chat-box-details__instance external" id="deal-chat-external">
                              <CommentBox />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
      </div>
    );
  }
}
