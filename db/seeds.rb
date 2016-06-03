# TODO
# Documents
# DealDocuments
# DocumentSigners


# Create a user
puts "Creating the first user"
user = FactoryGirl.create(:user, email: 'organization.admin@doxly.com')

# Create an organization created by that user
# Note that creating an organization with created_by will also create
# an organization user
puts "Creating the first organization"
organization = FactoryGirl.create(:organization, created_by: user.id)

# More users for that organization
puts "Creating the 10 internal users"
internal_users = FactoryGirl.create_list(:user, 10, :with_organization_user, organization_id: organization.id, email_domain: user.email_domain)
puts "Creating the 10 external users"
external_users = FactoryGirl.create_list(:user, 10, :with_organization_user, organization_id: organization.id)

users = internal_users + external_users

# Create some deals
# Creating a deal also creates two default categories -
# DiligenceCategory and ClosingCategory
puts "Creating some deals"
deals = FactoryGirl.create_list(:deal, rand(5) + 1, organization_user: user.organization_user)

deals.each do |deal|

  # Add a subset of the users in the organization as collaborators
  collaborators = users.sample(10)
  
  puts "Adding collaborator to deal #{deal.id}"
  collaborators.each do |collaborator|
    deal.add_collaborator! collaborator.organization_user, user.organization_user
  end

  # A random subset of the collaborators will also star the deal
  puts "Starring the deal"
  ([user] + collaborators).sample(6).each do |collaborator|
    collaborator.organization_user.star! deal
  end

  deal.categories.each do |category|
    # Create some sections
    puts "Creating some sections in #{category.name}"
    sections = FactoryGirl.create_list(:section, rand(5), category_id: category.id)
    # Create some tasks inside the sections
    sections.each do |section|
      puts "Creating some tasks inside section #{section.name}"
      tasks = FactoryGirl.create_list(:task, rand(10), section_id: section.id, assignee_id: collaborators.sample.organization_user.id, organization_user_id: user.organization_user.id)

      tasks.each do |task|
        # Create some comments on these tasks
        comments = FactoryGirl.create_list(:comment, rand(10), organization_user_id: ([user] + collaborators).sample.organization_user.id, commentable: task)
        # Create some folders inside these tasks
        folders = FactoryGirl.create_list(:folder, rand(10), created_by: ([user] + collaborators).sample, task_id: task.id)
        # Create some comments on the folders
        folders.each do |folder|
          comments = FactoryGirl.create_list(:comment, rand(10), organization_user_id: ([user] + collaborators).sample.organization_user.id, commentable: folder)
        end

        # Create some documents inside these folders
        # Create some comments on these documents
      end

      # Create some documents
      # Create some comments
    end

  end
end



# Assign users as collaborators

# Assign some of these deals as starred deals




# Now lets do this a few more times


# avatars = [1, 2, 3, 4, 5, 6]

# puts "Started creating Users"
# User.create(
#   #id: 1,
#   first_name: 'Alex',
#   last_name: 'Vaughn',
#   email: 'viola.wintheiser@panda.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 2,
#   first_name: 'Harvey',
#   last_name: 'Specter',
#   email: 'albertha_carroll@panda.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 3,
#   first_name: 'Rebecca',
#   last_name: 'Moss',
#   email: 'estefenia.larkin@panda.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 4,
#   first_name: 'Louisa',
#   last_name: 'Curtis',
#   email: 'bret.flatley@panda.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 5,
#   first_name: 'Cecelia',
#   last_name: 'Hopkins',
#   email: 'hahn.jabari@yahoo.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 6,
#   first_name: 'Alvin',
#   last_name: 'Jones',
#   email: 'craig_rice@gmail.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 7,
#   first_name: 'Celia',
#   last_name: 'Clark',
#   email: 'bernhard_thiel@art.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 8,
#   first_name: 'Chad',
#   last_name: 'Copeland',
#   email: 'glover.destin@io.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 9,
#   first_name: 'Louisa',
#   last_name: 'Gilbert',
#   email: 'alysa.collier@yahoo.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 10,
#   first_name: 'Clifford',
#   last_name: 'Snyder',
#   email: 'tom_gerhold@redhat.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 11,
#   first_name: 'Jeff',
#   last_name: 'Daniels',
#   email: 'jarrod_sauer@gmail.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 12,
#   first_name: 'Mabel',
#   last_name: 'Valdez',
#   email: 'roma.buckridge@yahoo.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 13,
#   first_name: 'Christian',
#   last_name: 'Erickson',
#   email: 'martine.hayes@gmail.com',
#   password: '12345678',
#   confirmed_at: Time.now,
#   role: 'Normal',
#   activated: false,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )
# User.create(
#   #id: 14,
#   first_name: 'Super',
#   last_name: 'User',
#   email: 'knightang11@gmail.com',
#   password: 'p@ssw0rd',
#   confirmed_at: Time.now,
#   role: 'Super',
#   activated: true,
#   avatar_name: "/assets/img-avatar-#{avatars.sample}.png"
# )

# puts "Started creating Organizations"
# Organization.create(
#   #id: 1,
#   name: 'Panda Express',
#   created_by: 1,
#   email_domain: 'panda.com',
#   phone: '9876543240',
#   address: '#1021, River Palace',
#   activated: true
# )

# puts "Started creating Organization Users"
# OrganizationAdminUser.create(
#   #id: 1,
#   organization_id: 1,
#   user_id: 1
# )

# OrganizationInternalUser.create(
#   #id: 2,
#   organization_id: 1,
#   user_id: 2
# )

# OrganizationInternalUser.create(
#   #id: 3,
#   organization_id: 1,
#   user_id: 3
# )

# OrganizationInternalUser.create(
#   #id: 4,
#   organization_id: 1,
#   user_id: 4
# )

# OrganizationExternalUser.create(
#   #id: 5,
#   organization_id: 1,
#   user_id: 5
# )

# OrganizationExternalUser.create(
#   #id: 6,
#   organization_id: 1,
#   user_id: 6
# )

# OrganizationExternalUser.create(
#   #id: 7,
#   organization_id: 1,
#   user_id: 7
# )

# OrganizationExternalUser.create(
#   #id: 8,
#   organization_id: 1,
#   user_id: 8
# )

# OrganizationExternalUser.create(
#   #id: 9,
#   organization_id: 1,
#   user_id: 9
# )

# OrganizationExternalUser.create(
#   #id: 10,
#   organization_id: 1,
#   user_id: 10
# )

# OrganizationExternalUser.create(
#   #id: 11,
#   organization_id: 1,
#   user_id: 11
# )

# OrganizationExternalUser.create(
#   #id: 12,
#   organization_id: 1,
#   user_id: 12
# )

# OrganizationExternalUser.create(
#   #id: 13,
#   organization_id: 1,
#   user_id: 13
# )

# puts "Started creating Deals"
# Deal.create(
#   #id: 1,
#   organization_user_id: 1,
#   title: 'Project Panda',
#   client_name: 'Panda Express',
#   projected_close_date: '2016-07-24',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true
# )
# Deal.create(
#   #id: 2,
#   organization_user_id: 1,
#   title: 'Project Narwhal',
#   client_name: 'Cordelia Webb',
#   projected_close_date: '2016-03-18',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true

# )
# Deal.create(
#   #id: 3,
#   organization_user_id: 1,
#   title: 'Project Danger Zone',
#   client_name: 'Maverick',
#   projected_close_date: '2016-11-03',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true
# )
# Deal.create(
#   #id: 4,
#   organization_user_id: 1,
#   title: 'Project Dark Knight',
#   client_name: 'Mitchell Torres',
#   projected_close_date: '2016-01-31',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true,
#   status: 'Pending'
# )
# Deal.create(
#   #id: 5,
#   organization_user_id: 1,
#   title: 'Project Alpha Dog',
#   client_name: 'High Alpha',
#   projected_close_date: '2016-01-19',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true,
#   status: 'Ongoing'
# )
# Deal.create(
#   #id: 6,
#   organization_user_id: 1,
#   title: 'Project Lamonfort',
#   client_name: 'Phillip Howard',
#   projected_close_date: '2015-12-29',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true,
#   status: 'Archived'
# )
# Deal.create(
#   #id: 7,
#   organization_user_id: 1,
#   title: 'Project Helmerfurt',
#   client_name: 'Myrtle Rodriquez',
#   projected_close_date: '2015-12-18',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true
# )
# Deal.create(
#   #id: 8,
#   organization_user_id: 1,
#   title: 'Project South Paw',
#   client_name: 'Larry Alexander',
#   projected_close_date: '2015-12-12',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true
# )
# Deal.create(
#   #id: 9,
#   organization_user_id: 1,
#   title: 'Project Margarettaland',
#   client_name: 'Davin Romero',
#   projected_close_date: '2015-12-01',
#   transaction_type: Deal::TRANSACTION_TYPES.sample,
#   deal_size: 1500000000,
#   activated: true
# )

# puts "Started creating Starred Deals"
# StarredDeal.create(
#   #id: 1,
#   organization_user_id: 1,
#   deal_id: 1
# )
# StarredDeal.create(
#   #id: 2,
#   organization_user_id: 10,
#   deal_id: 4
# )
# StarredDeal.create(
#   #id: 3,
#   organization_user_id: 11,
#   deal_id: 5
# )

# puts "Started creating Deal Collaborators"
# DealCollaborator.create(
#   #id: 1,
#   deal_id: 1,
#   organization_user_id: 1,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 2,
#   deal_id: 1,
#   organization_user_id: 2,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 3,
#   deal_id: 1,
#   organization_user_id: 3,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 4,
#   deal_id: 1,
#   organization_user_id: 4,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 5,
#   deal_id: 1,
#   organization_user_id: 5,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 6,
#   deal_id: 1,
#   organization_user_id: 6,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 7,
#   deal_id: 2,
#   organization_user_id: 2,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 8,
#   deal_id: 3,
#   organization_user_id: 3,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 9,
#   deal_id: 4,
#   organization_user_id: 4,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 10,
#   deal_id: 4,
#   organization_user_id: 10,
#   added_by: 4
# )
# DealCollaborator.create(
#   #id: 11,
#   deal_id: 5,
#   organization_user_id: 1,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 12,
#   deal_id: 6,
#   organization_user_id: 2,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 13,
#   deal_id: 7,
#   organization_user_id: 3,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 14,
#   deal_id: 8,
#   organization_user_id: 4,
#   added_by: 1
# )
# DealCollaborator.create(
#   #id: 15,
#   deal_id: 9,
#   organization_user_id: 9,
#   added_by: 1
# )

# puts "Started creating Sections"
# Section.create(
#   #id: 1,
#   name: 'Corporate Structure, Equity Capital & Records',
#   deal_id: 1,
#   category_id: 1,
#   created_by: 1,
#   activated: true
# )
# Section.create(
#   #id: 2,
#   name: 'Financial Data, Financings and Indebtedness',
#   deal_id: 1,
#   category_id: 1,
#   created_by: 1,
#   activated: true
# )
# Section.create(
#   #id: 3,
#   name: 'Pre-closing',
#   deal_id: 1,
#   category_id: 1,
#   created_by: 1,
#   activated: true
# )
# Section.create(
#   #id: 4,
#   name: 'Closing',
#   deal_id: 1,
#   category_id: 1,
#   created_by: 1,
#   activated: true
# )

# puts "Started creating Tasks"
# Task.create(
#   #id: 1,
#   title: 'Partnerships, JVS and Subsidiaries',
#   description: 'Partnerships, JVS and Subsidiaries',
#   section_id: 1,
#   assignee_id: 2,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# task = Task.create(
#   #id: 2,
#   title: 'Meeting Minutes',
#   description: 'To the extend not previously provided, all minutes of meeting'+
#                'and written consents of the board of directors and stockholders',
#   section_id: 1,
#   assignee_id: 2,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 3,
#   title: 'Meeting Materials Provided to BOD',
#   description: 'Meeting Materials Provided to BOD',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )
# Task.create(
#   #id: 4,
#   title: 'Annual and Quaterly Reports',
#   description: 'Annual and Quaterly Reports',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 5,
#   title: 'Correspndance Related to Blue Sky Laws',
#   description: 'Correspndance Related to Blue Sky Laws',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )
# Task.create(
#   #id: 6,
#   title: 'Equity Intrest Claims',
#   description: 'Equity Intrest Claims',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )
# Task.create(
#   #id: 7,
#   title: 'Conflict of Interest, Code of Ethics and Cor..',
#   description: 'Conflict of Interest, Code of Ethics and Cor..',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )
# Task.create(
#   #id: 8,
#   title: 'Options, Warrents and Other Commitments',
#   description: 'Options, Warrents and Other Commitments',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 9,
#   title: '409 Valuations',
#   description: '409 Valuations',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 10,
#   title: 'Offering Circulars, PPMs, Etc.',
#   description: 'Offering Circulars, PPMs, Etc.',
#   section_id: 1,
#   assignee_id: 3,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 11,
#   title: 'Options, Warrents and Other Commitments',
#   description: 'Options, Warrents and Other Commitments',
#   section_id: 2,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )
# Task.create(
#   #id: 12,
#   title: 'Term Sheet',
#   description: 'Term Sheet',
#   section_id: 3,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 13,
#   title: 'Diligence',
#   description: 'Diligence',
#   section_id: 3,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 14,
#   title: 'Partnerships, JVS and Subsidiaries',
#   description: 'Partnerships, JVS and Subsidiaries',
#   section_id: 4,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )
# Task.create(
#   #id: 15,
#   title: 'Employeement Agreements',
#   description: 'Employeement Agreements',
#   section_id: 4,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )
# Task.create(
#   #id: 16,
#   title: 'Board Consent',
#   description: 'Board Consent',
#   section_id: 4,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 17,
#   title: 'Stockholder Consent',
#   description: 'Stockholder Consent',
#   section_id: 4,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Complete'
# )
# Task.create(
#   #id: 18,
#   title: 'Escrow Agreements',
#   description: 'Escrow Agreements',
#   section_id: 4,
#   assignee_id: 4,
#   organization_user_id: 1,
#   deal_id: 1,
#   status: 'Incomplete'
# )

# puts "Started creating Folders"
# Folder.create(
#   #id: 1,
#   name: 'Subcmpany B',
#   task_id: '1',
#   created_by: 1,
#   activated: true
# )

# puts "Started creating Documents"
# Document.create(
#   #id: 1,
#   file_name: 'Subcmpany A',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 2,
#   file_name: 'Joint Venture C',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 3,
#   file_name: 'Meeting Minutes - January 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 4,
#   file_name: 'Meeting Minutes - February 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 5,
#   file_name: 'Meeting Minutes - March 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 6,
#   file_name: 'Meeting Minutes - April 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 7,
#   file_name: 'Meeting Minutes - May 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 8,
#   file_name: 'Meeting Minutes - June 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 9,
#   file_name: 'Meeting Minutes - July 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 10,
#   file_name: 'Meeting Minutes - August 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 11,
#   file_name: 'Meeting Minutes - September 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 12,
#   file_name: 'Meeting Minutes - January 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 13,
#   file_name: 'Meeting Minutes - November 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 14,
#   file_name: 'Meeting Minutes - December 2015',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 15,
#   file_name: 'Term Sheet',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 16,
#   file_name: 'Purchase Agreement',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 17,
#   file_name: 'Exhibit A Schedule of Purchasers',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 18,
#   file_name: 'Exhibit B Bill of Sale',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 19,
#   file_name: 'Exhibit C Agreement and Assumption Agreement',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 20,
#   file_name: 'Exhibit D Form of Third Party Consent',
#   file_size: '1000',
#   file_type: 'ppt',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 21,
#   file_name: 'Michael Scott',
#   file_size: '1000',
#   file_type: 'xls',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 22,
#   file_name: 'David Wallace',
#   file_size: '1000',
#   file_type: 'pdf',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 23,
#   file_name: 'Dwight Schrute',
#   file_size: '1000',
#   file_type: 'image',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )
# Document.create(
#   #id: 24,
#   file_name: 'Pam Beasley',
#   file_size: '1000',
#   file_type: 'pdf',
#   file_uploaded_at: Time.now(),
#   created_by: 1,
#   activated: true
# )

# puts "Started creating DealDocuments"
# DealDocument.create(
#   document_id: 1,
#   documentable_type: 'Task',
#   documentable_id: '1',
# )
# DealDocument.create(
#   document_id: 2,
#   documentable_type: 'Task',
#   documentable_id: '1',
# )
# DealDocument.create(
#   document_id: 3,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 4,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 5,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 6,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 7,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 8,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 9,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 10,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 11,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 12,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 13,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 14,
#   documentable_type: 'Task',
#   documentable_id: '2',
# )
# DealDocument.create(
#   document_id: 15,
#   documentable_type: 'Task',
#   documentable_id: '14',
# )
# DealDocument.create(
#   document_id: 16,
#   documentable_type: 'Task',
#   documentable_id: '14',
# )
# DealDocument.create(
#   document_id: 17,
#   documentable_type: 'Task',
#   documentable_id: '14',
# )
# DealDocument.create(
#   document_id: 18,
#   documentable_type: 'Task',
#   documentable_id: '14',
# )
# DealDocument.create(
#   document_id: 19,
#   documentable_type: 'Task',
#   documentable_id: '14',
# )
# DealDocument.create(
#   document_id: 20,
#   documentable_type: 'Task',
#   documentable_id: '14',
# )
# DealDocument.create(
#   document_id: 21,
#   documentable_type: 'Task',
#   documentable_id: '15',
# )
# DealDocument.create(
#   document_id: 22,
#   documentable_type: 'Task',
#   documentable_id: '15',
# )
# DealDocument.create(
#   document_id: 23,
#   documentable_type: 'Task',
#   documentable_id: '15',
# )
# DealDocument.create(
#   document_id: 24,
#   documentable_type: 'Task',
#   documentable_id: '15',
# )

# puts "Create another folder so it shows up in recents"
# Folder.create(
#   #id: 1,
#   name: 'Important Documents',
#   task_id: '1',
#   created_by: 1,
#   activated: true
# )

# puts "Started creating Document Signers"
# DocumentSigner.create(
#   #id: 1,
#   document_id: 15,
#   organization_user_id: 1,
#   signed: true,
#   signed_at: Time.now()
# )
# DocumentSigner.create(
#   #id: 2,
#   document_id: 15,
#   organization_user_id: 2,
#   signed: true,
#   signed_at: Time.now()
# )
# DocumentSigner.create(
#   #id: 3,
#   document_id: 15,
#   organization_user_id: 3,
#   signed: true,
#   signed_at: Time.now()
# )
# DocumentSigner.create(
#   #id: 4,
#   document_id: 16,
#   organization_user_id: 4,
#   signed: false,
#   signed_at: Time.now()
# )
# DocumentSigner.create(
#   #id: 5,
#   document_id: 16,
#   organization_user_id: 5,
#   signed: false,
#   signed_at: Time.now()
# )
# DocumentSigner.create(
#   #id: 6,
#   document_id: 16,
#   organization_user_id: 6,
#   signed: false,
#   signed_at: Time.now()
# )

# puts "Started creating Comments"
# document = Document.find(15)
# Comment.create(
#   #id: 1,
#   organization_user_id: 1,
#   commentable: task, 
#   comment_type: 'Internal',
#   comment: 'Looks like we are missing the June Meeting Minutes.'
# )
# Comment.create(
#   #id: 2,
#   organization_user_id: 2,
#   commentable: task, 
#   comment_type: 'Internal',
#   comment: 'Cancelled due to weather.'
# )
# Comment.create(
#   #id: 3,
#   organization_user_id: 1,
#   commentable: task, 
#   comment_type: 'Internal',
#   comment: 'Sound Good. Thanks!'
# )
# Comment.create(
#   #id: 4,
#   organization_user_id: 1,
#   commentable: document, 
#   comment_type: 'Internal',
#   comment: 'Just signed the Term Sheet. Looking forward to working on the deal.'
# )
# Comment.create(
#   #id: 5,
#   organization_user_id: 2,
#   commentable: document, 
#   comment_type: 'Internal',
#   comment: 'Great. I will send the Purchase Agreement by Friday.'
# )

# puts "Started creating Notifications"
# Notification.create(
#   #id: 1,
#   organization_user_id: 1,
#   message: 'Welcome back to Doxly!',
#   status: 'unread'
# )