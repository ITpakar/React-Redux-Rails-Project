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

        # TODO Create some documents inside these folders
        # TODO Create some comments on these documents
      end

      # TODO Create some documents
      # TODO Create some comments
    end

  end
end