import classnames from 'classnames';
import React, { PropTypes } from 'react';


export default class ProgressPieChart extends React.Component {

  degrees() {
    return 360 * this.props.percent / 100;
  }

  render() {
    return (
      <div className={classnames("progress-pie-chart", {"gt-50": this.props.percent > 50})}>
        <div className="ppc-progress">
          <div className="ppc-progress-fill" style={{transform: `rotate(${this.degrees()}deg)`}}></div>
        </div>
        <div className="ppc-percents">
          <div className="pcc-percents-wrapper">
            <span className={classnames({full: this.props.percent === 100})}></span>
          </div>
        </div>
      </div>
    );
  }
}