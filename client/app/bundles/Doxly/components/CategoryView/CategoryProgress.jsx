import React, { PropTypes } from 'react';
import classnames from 'classnames';

export default class CategoryProgress extends React.Component {

  static propTypes = {
    title: PropTypes.string,
    totalCount: PropTypes.number,
    completedCount: PropTypes.number
  }

  render() {
    let percentCompleted = 100 * this.props.completedCount/this.props.totalCount
    let title = this.props.title;

    if (title) {
      title = title.toUpperCase();
    }

    return (
      <div className="deal-progress-statistic">
          <div className="title">{title} TASKS COMPLETE <strong>{this.props.completedCount}/{this.props.totalCount}</strong></div>
          <div className={classnames("progress", {'finished': percentCompleted == 100})}>
              <div className="progress-bar" role="progressbar" aria-valuenow={percentCompleted} aria-valuemin="0" aria-valuemax="100" style={{width: `${percentCompleted}%`}}>
                  <span className="sr-only">{percentCompleted}% Complete</span>
              </div>
          </div>
      </div>
    );
  }
}
