require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    all_students = DB[:conn].execute("SELECT * FROM students")
    all_students.map do |row|
      self.new_from_db(row)
    end
  end

  def self.all_students_in_grade_9
    found_students = DB[:conn].execute("SELECT * FROM students WHERE grade = 9")
    found_students.map do |row|
      self.new_from_db(row)
    end
  end
  
  def self.all_students_in_grade_X(x)
    found_students = DB[:conn].execute("SELECT * FROM students WHERE grade = ?", x)
    found_students.map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    found_students = DB[:conn].execute("SELECT * FROM students WHERE grade < 12")
    found_students.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    found_students = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?", x)
    found_students.map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    found_student = DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")
      self.new_from_db(found_student[0])
  end

  def self.find_by_name(name)
    found_student = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)
    self.new_from_db(found_student[0])
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
end
