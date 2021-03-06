class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map { |x| self.new_from_db(x) }
  end

  def self.find_by_name(name)
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE name = ?
        LIMIT 1
      SQL
    
      DB[:conn].execute(sql, name).map { |x| self.new_from_db(x) }.first
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
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    LIMIT 1
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12
    LIMIT 1
    SQL
  
    DB[:conn].execute(sql).map { |x| self.new_from_db(x) }
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY name DESC
    SQL

    DB[:conn].execute(sql).map { |y| self.new_from_db(y) }[0, x]
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY id DESC
    SQL

    DB[:conn].execute(sql).map { |x| self.new_from_db(x) }[-1]  # hehe ;^)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x).map { |y| self.new_from_db(y) }
  end
end