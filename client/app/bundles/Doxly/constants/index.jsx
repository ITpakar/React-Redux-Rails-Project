// We can namespace like so

export default {
  USERS: {
    LOGIN: 'LOGIN'
  },
  COMMENTS: {
  	LOAD: '@doxly/comments/LOAD',
  	ADD: '@doxly/comments/ADD'
  },
  COLLABORATORS: {
    LOAD: '@doxly/collaborators/LOAD',
    ADD: '@doxly/collaborators/ADD',
    REMOVE: '@doxly/collaborators/REMOVE'
  },
  DEALS: {
    ADD_STARRED: '@doxly/deals/ADD_STARRED',
    REMOVE_STARRED: '@doxly/deals/REMOVE_STARRED'
  },
  REQUESTS: {
    LOADING: "LOADING",
    FINISH_LOADING: "FINISH_LOADING",
    LOAD_SECTIONS: "LOAD_SECTIONS",
    LOAD_DILIGENCE_SECTIONS: "LOAD_DILIGENCE_SECTIONS",
    LOAD_CLOSING_SECTIONS: "LOAD_CLOSING_SECTIONS",
    LOAD_DEAL_COLLABORATORS: "LOAD_DEAL_COLLABORATORS",
    UPDATE_TASK: "UPDATE_TASK",
    LOAD_DOCUMENT: "LOAD_DOCUMENT",
    CREATE_VERSION: "CREATE_VERSION"
  }
}
