class User

  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    result = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id
    SQL
    User.new(result)
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.get_first_row(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = :fname AND lname = :lname
    SQL
    User.new(results)
  end

  def self.all
    QuestionsDatabase.execute(<<-SQL)
      SELECT
        *
      FROM
        users
    SQL
  end

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    author_id = QuestionsDatabase.get_first_row(<<-SQL, fname: @fname, lname: @lname)
      SELECT
        id
      FROM
        users
      WHERE
        fname = :fname AND
        lname = :lname
    SQL
    id_num = author_id["id"]
    Question::find_by_author_id(id_num)
  end

  def authored_replies
    author_id = QuestionsDatabase.get_first_row(<<-SQL, fname: @fname, lname: @lname)
      SELECT
        id
      FROM
        users
      WHERE
        fname = :fname AND
        lname = :lname
    SQL
    id_num = author_id["id"]
    Reply::find_by_user_id(id_num)
  end

  def followed_questions
    QuestionFollow::followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike::liked_questions_for_user_id(@id)
  end

  def average_karma
    karma_hash = QuestionsDatabase.get_first_row(<<-SQL, user_id: @id )
      SELECT
        CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS avg
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = :user_id
    SQL
    karma_hash['avg']
  end

  def save
    if @id.nil?
      QuestionsDatabase.execute(<<-SQL, fname: @fname, lname: @lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (:fname, :lname)
      SQL
      @id = QuestionsDatabase.last_insert_row_id
    else
      QuestionsDatabase.execute(<<-SQL, id: @id, fname: @fname, lname: @lname)
        UPDATE
          users
        SET
          fname = :fname,
          lname = :lname
        WHERE
          id = :id
      SQL
    end
  end

end
