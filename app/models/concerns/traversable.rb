module Traversable
  extend ActiveSupport::Concern

  def traverse_up_to klass
    return self if self.class == klass
    return self.send(self.association_map[klass.to_s]) if self.association_map.keys.include? klass.to_s
    case self
    when Comment
      return self.commentable.traverse_up_to klass
    # Need to decide how we can get traverse_up for Document model
    # when Document
    #   return self.documentable.traverse_up_to klass
    when Folder
      return self.parent.traverse_up_to klass
    when Task
      return self.section.traverse_up_to klass
    end
  end

  # This will return true if self has a belongs_to association
  # on klass
  # So for example, if comment belongs_to :task
  # then comment.belongs_to? Task will be true
  def belongs_to? klass
    sym = klass.to_s.downcase.to_sym
    self.class.reflect_on_all_associations(:belongs_to).map(&:name).include? sym
  end

  # This will create a hash of all associations with key = klass and value = association name
  def association_map
    Hash[*self.class.reflect_on_all_associations(:belongs_to).map{|assoc| [assoc.class_name, assoc.name]}.flatten]
  end
end