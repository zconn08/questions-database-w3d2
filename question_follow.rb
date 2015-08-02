class QuestionFollow
  def self.find_by_id(id)
    result = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = :id
    SQL
    QuestionFollow.new(result)
  end

  def self.followers_for_question_id(question_id)
    QuestionsDatabase.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        question_id = :question_id
    SQL
  end

  def self.followed_questions_for_user_id(user_id)
    QuestionsDatabase.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      WHERE
        user_id = :user_id
    SQL
  end

  def self.most_followed_questions(n)
    QuestionsDatabase.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      GROUP BY
        question_follows.question_id
      ORDER BY
        COUNT(question_follows.question_id) DESC LIMIT :n
    SQL
  end

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
