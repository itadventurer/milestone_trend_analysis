# Der Project–Helper
module ProjectHelper
  # :nodoc:
  def dragons
    li(@project.name) == $y ? @a : ""
  end
end
