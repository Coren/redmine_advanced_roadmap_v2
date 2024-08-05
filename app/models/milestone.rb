class Milestone < ActiveRecord::Base

  belongs_to :user
  belongs_to :project
  has_many :milestone_versions, :dependent => :destroy
  has_many :versions, :through => :milestone_versions

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => [:project_id]
  validates_length_of :name, :maximum => 60
  validates :effective_date, :date => true, :allow_nil => true

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
