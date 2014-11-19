class Milestone < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :project
  has_many :milestone_versions, :dependent => :destroy
  has_many :versions, :through => :milestone_versions

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:project_id]
  validates_length_of :name, :maximum => 60
  validates_format_of :effective_date, :with => /^\d{4}-\d{2}-\d{2}$/, :message => 'activerecord_error_not_a_date', :allow_nil => true
  
  def to_s
    name
  end
  
  def <=>(milestone)
    if self.effective_date
      milestone.effective_date ? (self.effective_date == milestone.effective_date ? self.name <=> milestone.name : self.effective_date <=> milestone.effective_date) : -1
    else
      milestone.effective_date ? 1 : (self.name <=> milestone.name)
    end
  end

  def versions?(version)
    versions.index(version) != nil
  end

  def completed?
    effective_date && (effective_date <= Date.today)
  end

end
