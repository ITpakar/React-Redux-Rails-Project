import React, { PropTypes } from 'react';

// Props
// 

export default class CategoryView extends React.Component {
  render() {
    return (
      <div role="tabpanel" class="tab-pane " id="tab-deal-diligence">
        <div class="container-fluid">
          <div class="row">
              <DealProgress />
          </div>
          <div class="row">
              <div class="toolbar-box">
                  <form>
                      <SearchInput />
                      <GroupedSelectInput />
                      <a href="#" class="btn-add-circle btn-add-deal" data-toggle="popover" data-content="<div class='popover-menu-deal'><a href='#' data-target='#modal-new-section' data-toggle='modal'>New Section</a><a href='#' data-target='#modal-new-task' data-toggle='modal'>New Task</a><a href='#' data-target='#modal-new-file' data-toggle='modal'>New File</a><a href='#' data-target='#modal-new-folder' data-toggle='modal'>New Folder</a></div>"></a>
                  </form>
              </div>

          </div>

          <div class="row">
              <div class="content-deal">
                  <div class="content-deal-wrapper">
                      <div class="content-deal-left">
                        <TaskList />
                      </div>
                      <div class="content-deal-right">
                          <TaskDetails />
                          <CommentBox />
                      </div>
                  </div>
              </div>
          </div>

        </div>
      </div>
    )
  }
}