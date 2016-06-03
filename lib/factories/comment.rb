require 'factory_girl_rails'
require 'ffaker'

FactoryGirl.define do 
  factory :comment do
    transient do
        commentable nil
    end

    organization_user_id    nil
    comment_type            {Comment::TYPES.sample}
    comment                 {FFaker::Lorem.sentence}
    commentable_id          {commentable.id}
    commentable_type        {commentable.class.to_s}
  end
end