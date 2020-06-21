require 'pry'
class Student
  attr_accessor :id, :name, :grade
   
  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end



  def self.all
   result = DB[:conn].execute(
      "SELECT * FROM students"
     )
   result.map do |student|
     self.new_from_db(student) #use the method built above converting each row into an instance
   end
  end



  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    row = DB[:conn].execute(
        "SELECT * FROM students WHERE name = ?",   #find the student in DB
        [name]
      )
    #binding.pry  
    self.new_from_db(row[0])  #convert a row into an instance
  end
  
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_9
    students = DB[:conn].execute(
        "SELECT * FROM students WHERE grade = 9"     #1. retrieve from DB
      )
    students.map {|student| self.new_from_db(student[0])}    #2. convert to an instance
  end
  
  
  def self.students_below_12th_grade
    students = DB[:conn].execute(
        "SELECT * FROM students WHERE grade < 12"
      )
    students.map {|student| self.new_from_db(student)}
  end
  
  def self.first_X_students_in_grade_10(x)
    students = DB[:conn].execute(
        "SELECT * FROM students WHERE grade = 10 LIMIT 2"
      )
    students.map {|student| self.new_from_db(student)}
  end
  
  def self.first_student_in_grade_10
    students = DB[:conn].execute(
        "SELECT * FROM students WHERE grade = 10 LIMIT 1"
      )
    #binding.pry  
    results = students.map {|student| self.new_from_db(student)} #it returns an array
    results[0]  # return as an instance
  end
  
  def self.all_students_in_grade_X(x)
    students = DB[:conn].execute(
        "SELECT * FROM students WHERE grade = ?",
        [x]
      )
    students.map {|student| self.new_from_db(student)}
  end
  
end