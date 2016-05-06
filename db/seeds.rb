puts "Started creating Users"
User.create(
  #id: 1,
  first_name: 'Alex',
  last_name: 'Vaughn',
  email: 'viola.wintheiser@panda.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 2,
  first_name: 'Harvey',
  last_name: 'Specter',
  email: 'albertha_carroll@panda.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 3,
  first_name: 'Rebecca',
  last_name: 'Moss',
  email: 'estefenia.larkin@panda.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 4,
  first_name: 'Louisa',
  last_name: 'Curtis',
  email: 'bret.flatley@panda.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 5,
  first_name: 'Cecelia',
  last_name: 'Hopkins',
  email: 'hahn.jabari@yahoo.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 6,
  first_name: 'Alvin',
  last_name: 'Jones',
  email: 'craig_rice@gmail.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 7,
  first_name: 'Celia',
  last_name: 'Clark',
  email: 'bernhard_thiel@art.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 8,
  first_name: 'Chad',
  last_name: 'Copeland',
  email: 'glover.destin@io.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 9,
  first_name: 'Louisa',
  last_name: 'Gilbert',
  email: 'alysa.collier@yahoo.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 10,
  first_name: 'Clifford',
  last_name: 'Snyder',
  email: 'tom_gerhold@redhat.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 11,
  first_name: 'Jeff',
  last_name: 'Daniels',
  email: 'jarrod_sauer@gmail.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 12,
  first_name: 'Mabel',
  last_name: 'Valdez',
  email: 'roma.buckridge@yahoo.com',
  password: '12345678',
  confirmed_at: Time.now
)
User.create(
  #id: 13,
  first_name: 'Christian',
  last_name: 'Erickson',
  email: 'martine.hayes@gmail.com',
  password: '12345678',
  confirmed_at: Time.now
)

puts "Started creating Organizations"
Organization.create(
  #id: 1,
  name: 'Panda Express',
  created_by: 1,
  email_domain: 'panda.com',
  phone: '9876543240',
  address: '#1021, River Palace',
  activated: true
)

puts "Started creating Organization Users"
OrganizationUser.create(
  #id: 1,
  organization_id: 1,
  user_id: 1,
  user_type: 'Admin'
)

OrganizationUser.create(
  #id: 2,
  organization_id: 1,
  user_id: 2,
  user_type: 'Internal'
)

OrganizationUser.create(
  #id: 3,
  organization_id: 1,
  user_id: 3,
  user_type: 'Internal'
)

OrganizationUser.create(
  #id: 4,
  organization_id: 1,
  user_id: 4,
  user_type: 'Internal'
)

OrganizationUser.create(
  #id: 5,
  organization_id: 1,
  user_id: 5,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 6,
  organization_id: 1,
  user_id: 6,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 7,
  organization_id: 1,
  user_id: 7,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 8,
  organization_id: 1,
  user_id: 8,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 9,
  organization_id: 1,
  user_id: 9,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 10,
  organization_id: 1,
  user_id: 10,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 11,
  organization_id: 1,
  user_id: 11,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 12,
  organization_id: 1,
  user_id: 12,
  user_type: 'Outside'
)

OrganizationUser.create(
  #id: 13,
  organization_id: 1,
  user_id: 13,
  user_type: 'Outside'
)

puts "Started creating Deals"
Deal.create(
  #id: 1,
  organization_id: 1,
  title: 'Project Panda',
  client_name: 'Panda Express',
  projected_close_date: '2016-07-24',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 1,
  activated: true
)
Deal.create(
  #id: 2,
  organization_id: 1,
  title: 'Project Narwhal',
  client_name: 'Cordelia Webb',
  projected_close_date: '2016-03-18',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 2,
  activated: true
)
Deal.create(
  #id: 3,
  organization_id: 1,
  title: 'Project Danger Zone',
  client_name: 'Maverick',
  projected_close_date: '2016-11-03',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 3,
  activated: true
)
Deal.create(
  #id: 4,
  organization_id: 1,
  title: 'Project Dark Knight',
  client_name: 'Mitchell Torres',
  projected_close_date: '2016-01-31',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 4,
  activated: true
)
Deal.create(
  #id: 5,
  organization_id: 1,
  title: 'Project Alpha Dog',
  client_name: 'High Alpha',
  projected_close_date: '2016-01-19',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 1,
  activated: true
)
Deal.create(
  #id: 6,
  organization_id: 1,
  title: 'Project Lamonfort',
  client_name: 'Phillip Howard',
  projected_close_date: '2015-12-29',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 2,
  activated: true
)
Deal.create(
  #id: 7,
  organization_id: 1,
  title: 'Project Helmerfurt',
  client_name: 'Myrtle Rodriquez',
  projected_close_date: '2015-12-18',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 3,
  activated: true
)
Deal.create(
  #id: 8,
  organization_id: 1,
  title: 'Project South Paw',
  client_name: 'Larry Alexander',
  projected_close_date: '2015-12-12',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 4,
  activated: true
)
Deal.create(
  #id: 9,
  organization_id: 1,
  title: 'Project Margarettaland',
  client_name: 'Davin Romero',
  projected_close_date: '2015-12-01',
  transaction_type: 'Merger',
  deal_size: '$1,500,000,000',
  completion_percent: 9,
  admin_user_id: 9,
  activated: true
)

puts "Started creating Starred Deals"
StarredDeal.create(
  #id: 1,
  user_id: 1,
  deal_id: 1
)
StarredDeal.create(
  #id: 2,
  user_id: 10,
  deal_id: 4
)
StarredDeal.create(
  #id: 3,
  user_id: 11,
  deal_id: 5
)

puts "Started creating Deal Collaborators"
DealCollaborator.create(
  #id: 1,
  deal_id: 1,
  user_id: 1,
  added_by: 1
)
DealCollaborator.create(
  #id: 2,
  deal_id: 1,
  user_id: 2,
  added_by: 1
)
DealCollaborator.create(
  #id: 3,
  deal_id: 1,
  user_id: 3,
  added_by: 1
)
DealCollaborator.create(
  #id: 4,
  deal_id: 1,
  user_id: 4,
  added_by: 1
)
DealCollaborator.create(
  #id: 5,
  deal_id: 1,
  user_id: 5,
  added_by: 1
)
DealCollaborator.create(
  #id: 6,
  deal_id: 1,
  user_id: 6,
  added_by: 1
)

puts "Started creating Categories"
Category.create(
  #id: 1,
  name: 'Diligence',
  activated: true
)
Category.create(
  #id: 2,
  name: 'Closing',
  activated: true
)

puts "Started creating Sections"
Section.create(
  #id: 1,
  name: 'Corporate Structure, Equity Capital & Records',
  deal_id: 1,
  category_id: 1,
  created_by: 1,
  activated: true
)
Section.create(
  #id: 2,
  name: 'Financial Data, Financings and Indebtedness',
  deal_id: 1,
  category_id: 1,
  created_by: 1,
  activated: true
)
Section.create(
  #id: 3,
  name: 'Pre-closing',
  deal_id: 1,
  category_id: 2,
  created_by: 1,
  activated: true
)
Section.create(
  #id: 4,
  name: 'Closing',
  deal_id: 1,
  category_id: 2,
  created_by: 1,
  activated: true
)

puts "Started creating Tasks"
Task.create(
  #id: 1,
  title: 'Partnerships, JVS and Subsidiaries',
  description: 'Partnerships, JVS and Subsidiaries',
  section_id: 1,
  assingnee_id: 2,
  created_by: 1
)
Task.create(
  #id: 2,
  title: 'Meeting Minutes',
  description: 'To the extend not previously provided, all minutes of meeting'+
               'and written consents of the board of directors and stockholders',
  section_id: 1,
  assingnee_id: 2,
  created_by: 1
)
Task.create(
  #id: 3,
  title: 'Meeting Materials Provided to BOD',
  description: 'Meeting Materials Provided to BOD',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 4,
  title: 'Annual and Quaterly Reports',
  description: 'Annual and Quaterly Reports',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 5,
  title: 'Correspndance Related to Blue Sky Laws',
  description: 'Correspndance Related to Blue Sky Laws',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 6,
  title: 'Equity Intrest Claims',
  description: 'Equity Intrest Claims',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 7,
  title: 'Conflict of Interest, Code of Ethics and Cor..',
  description: 'Conflict of Interest, Code of Ethics and Cor..',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 8,
  title: 'Options, Warrents and Other Commitments',
  description: 'Options, Warrents and Other Commitments',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 9,
  title: '409 Valuations',
  description: '409 Valuations',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 10,
  title: 'Offering Circulars, PPMs, Etc.',
  description: 'Offering Circulars, PPMs, Etc.',
  section_id: 1,
  assingnee_id: 3,
  created_by: 1
)
Task.create(
  #id: 11,
  title: 'Options, Warrents and Other Commitments',
  description: 'Options, Warrents and Other Commitments',
  section_id: 2,
  assingnee_id: 4,
  created_by: 1
)
Task.create(
  #id: 12,
  title: 'Term Sheet',
  description: 'Term Sheet',
  section_id: 3,
  assingnee_id: 4,
  created_by: 1
)
Task.create(
  #id: 13,
  title: 'Diligence',
  description: 'Diligence',
  section_id: 3,
  assingnee_id: 4,
  created_by: 1
)
Task.create(
  #id: 14,
  title: 'Partnerships, JVS and Subsidiaries',
  description: 'Partnerships, JVS and Subsidiaries',
  section_id: 4,
  assingnee_id: 4,
  created_by: 1
)
Task.create(
  #id: 15,
  title: 'Employeement Agreements',
  description: 'Employeement Agreements',
  section_id: 4,
  assingnee_id: 4,
  created_by: 1
)
Task.create(
  #id: 16,
  title: 'Board Consent',
  description: 'Board Consent',
  section_id: 4,
  assingnee_id: 4,
  created_by: 1
)
Task.create(
  #id: 17,
  title: 'Stockholder Consent',
  description: 'Stockholder Consent',
  section_id: 4,
  assingnee_id: 4,
  created_by: 1
)
Task.create(
  #id: 18,
  title: 'Escrow Agreements',
  description: 'Escrow Agreements',
  section_id: 4,
  assingnee_id: 4,
  created_by: 1
)

puts "Started creating Folders"
Folder.create(
  #id: 1,
  name: 'Subcmpany B',
  parent_type: 'Task',
  parent_id: '1',
  created_by: 1,
  activated: true
)

puts "Started creating Documents"
Document.create(
  #id: 1,
  file_name: 'Subcmpany A',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '1',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 2,
  file_name: 'Joint Venture C',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '1',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 3,
  file_name: 'Meeting Minutes - January 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 4,
  file_name: 'Meeting Minutes - February 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 5,
  file_name: 'Meeting Minutes - March 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 6,
  file_name: 'Meeting Minutes - April 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 7,
  file_name: 'Meeting Minutes - May 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 8,
  file_name: 'Meeting Minutes - June 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 9,
  file_name: 'Meeting Minutes - July 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 10,
  file_name: 'Meeting Minutes - August 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 11,
  file_name: 'Meeting Minutes - September 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 12,
  file_name: 'Meeting Minutes - January 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 13,
  file_name: 'Meeting Minutes - November 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 14,
  file_name: 'Meeting Minutes - December 2015',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '2',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 15,
  file_name: 'Term Sheet',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '12',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 16,
  file_name: 'Purchase Agreement',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '14',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 17,
  file_name: 'Exhibit A Schedule of Purchasers',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '14',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 18,
  file_name: 'Exhibit B Bill of Sale',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '14',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 19,
  file_name: 'Exhibit C Agreement and Assumption Agreement',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '14',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 20,
  file_name: 'Exhibit D Form of Third Party Consent',
  file_size: '1000',
  file_type: 'ppt',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '14',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 21,
  file_name: 'Michael Scott',
  file_size: '1000',
  file_type: 'xls',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '15',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 22,
  file_name: 'David Wallace',
  file_size: '1000',
  file_type: 'pdf',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '15',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 23,
  file_name: 'Dwight Schrute',
  file_size: '1000',
  file_type: 'image',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '15',
  created_by: 1,
  activated: true
)
Document.create(
  #id: 24,
  file_name: 'Pam Beasley',
  file_size: '1000',
  file_type: 'pdf',
  file_uploaded_at: Time.now(),
  parent_type: 'Task',
  parent_id: '15',
  created_by: 1,
  activated: true
)

puts "Started creating Document Signers"
DocumentSigner.create(
  #id: 1,
  document_id: 15,
  user_id: 1,
  signed: true,
  signed_at: Time.now()
)
DocumentSigner.create(
  #id: 2,
  document_id: 15,
  user_id: 2,
  signed: true,
  signed_at: Time.now()
)
DocumentSigner.create(
  #id: 3,
  document_id: 15,
  user_id: 3,
  signed: true,
  signed_at: Time.now()
)
DocumentSigner.create(
  #id: 4,
  document_id: 16,
  user_id: 4,
  signed: false,
  signed_at: Time.now()
)
DocumentSigner.create(
  #id: 5,
  document_id: 16,
  user_id: 5,
  signed: false,
  signed_at: Time.now()
)
DocumentSigner.create(
  #id: 6,
  document_id: 16,
  user_id: 6,
  signed: false,
  signed_at: Time.now()
)

puts "Started creating Comments"
Comment.create(
  #id: 1,
  user_id: 1,
  task_id: 2,
  comment_type: 'Internal',
  comment: 'Looks like we are missing the June Meeting Minutes.'
)
Comment.create(
  #id: 2,
  user_id: 2,
  task_id: 2,
  comment_type: 'Internal',
  comment: 'Cancelled due to weather.'
)
Comment.create(
  #id: 3,
  user_id: 1,
  task_id: 2,
  comment_type: 'Internal',
  comment: 'Sound Good. Thanks!'
)
Comment.create(
  #id: 4,
  user_id: 1,
  document_id: 15,
  comment_type: 'Internal',
  comment: 'Just signed the Term Sheet. Looking forward to working on the deal.'
)
Comment.create(
  #id: 5,
  user_id: 2,
  document_id: 15,
  comment_type: 'Internal',
  comment: 'Great. I will send the Purchase Agreement by Friday.'
)

puts "Started creating Notifications"
Notification.create(
  #id: 1,
  user_id: 1,
  message: 'Welcome back to Doxly!',
  status: 'unread'
)
