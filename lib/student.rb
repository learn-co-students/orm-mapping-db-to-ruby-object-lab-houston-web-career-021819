require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(name: name, grade: grade, id: id = nil)
    self.name = name
    self.grade = grade
    self.id = id
  end

  def self.new_from_db(row)
    Student.new(name: row[1],grade: row[2],id: row[0])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"

    found_students = DB[:conn].execute(sql)

    found_students.map do |student|
      Student.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = '#{name}' LIMIT 1"

    found_student = DB[:conn].execute(sql)[0]

    Student.new_from_db(found_student)
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
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    Student.all.select do |student|
      student.grade == 9
    end
  end

  def self.students_below_12th_grade
    Student.all.select do |student|
      student.grade < 12
    end
  end

  def self.first_X_students_in_grade_10(num_students)
    all_students_in_10 = []
    Student.all.each do |student|
      if student.grade == 10
        all_students_in_10 << student
      end
    end
    all_students_in_10.first(num_students)
  end

  def self.first_student_in_grade_10
    Student.all.find do |student|
      student.grade == 10
    end
  end

  def self.all_students_in_grade_X(grade)
    Student.all.select do |student|
      student.grade == grade
    end
  end

end
