import React, { PropTypes } from 'react';

export default class ChangesView extends React.Component {
  constructor(props, context) {
    super(props, context);
  }

  render() {
    var changes = this.props.changes;
    var displayedChanges = [];

    if (changes.length > 0) {
      for (let i = 0; i < changes.length; i++) {
        let change = changes[i];
        let displayChange = (
          <div className="change" key={"change_" + (i + 1)}>
            <div className="title">{change.title}</div>
            <div className="change-item removed">
              <div className="section">
                <p>{change.removed_section}</p>
              </div>
              <div className="details">
                <p>{change.removed_content}</p>
              </div>
            </div>
            <div className="change-item added">
              <div className="section">
                <p>{change.added_section}</p>
              </div>
              <div className="details">
                <p>{change.added_content}</p>
              </div>
            </div>
          </div>
        );

        displayedChanges.push(displayChange);
      }
    } else {
      displayedChanges.push(
        (<div className="no-changes-found" key="no_changes">No changes found</div>)
      );
    }

    return (
      <div className="panel panel-changes">
        {displayedChanges}
      </div>
    );
  }
}
