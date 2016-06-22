import React, { PropTypes } from 'react';
import _ from 'lodash';

import ProgressPieChart from './ProgressPieChart';

export default class Deal extends React.Component {

  static propTypes = {
    client_name: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    collaborators: PropTypes.arrayOf(PropTypes.shape({
      initials: PropTypes.string,
      avatar: PropTypes.string
    })),
    projected_close_date: PropTypes.string.isRequired
  }

  renderCollaborators(collaborators) {
    return (
      <div className="item-collaborators-wraper">
          {_.map(collaborators, function(collaborator, i) {
            console.log(collaborator);
            return collaborator.avatar ? (
              <a href="#" className="avatar" key={i}>
                <img src={collaborator.avatar} />
              </a>
            ) : (
              <a href="#" className="avatar initials" key={i}>
                {collaborator.initials}
              </a>
            ) ;
          })}
      </div>
    )
  }

  render() {
    return (
      <div className="project-item">
          <div className="item-percent">
              <ProgressPieChart percent={this.props.completion_percent} />
          </div>
          <div className="item-body">
              <a href={`/app/deals/${this.props.id}`} className="item-body__project">
                  <div className="title">{this.props.client_name}</div>
                  <div className="copy">
                    {this.props.title}
                    {(() => {
                      if (this.props.starred) {
                        return (
                          <span className="star"></span>
                        )
                      }
                    })()}
                  </div>
              </a>
              <div className="item-body__collaborators">
                  <div className="title">Collaborators</div>
                  {this.renderCollaborators(this.props.collaborators)}

              </div>
              <div className="item-body__timestamp">
                  <div className="title"><span className="timestamp">{this.props.projected_close_date}</span></div>
              </div>
          </div>
      </div>
    );
  }
}