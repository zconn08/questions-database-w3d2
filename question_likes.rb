class QuestionLike

  def self.find_by_id(id)
    result = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
    SQL
    QuestionLike.new(result)
  end

  def self.likers_for_question_id(question_id)
    QuestionsDatabase.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON question_likes.user_id = users.id
      WHERE
        question_id = :question_id
    SQL
  end

  def self.num_likes_for_question_id(question_id)
    likes_hash = QuestionsDatabase.get_first_row(<<-SQL, question_id: question_id)
      SELECT
        COUNT(question_id) as count
      FROM
        question_likes
      WHERE
        question_id = :question_id
      GROUP BY
        question_id
    SQL
    return 0 if likes_hash.empty?
    likes_hash['count']
  end

  def self.liked_questions_for_user_id(user_id)
    QuestionsDatabase.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        user_id = :user_id
    SQL
  end

  def self.most_liked_questions(n)
    QuestionsDatabase.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      GROUP BY
        question_likes.question_id
      ORDER BY
        COUNT(question_likes.question_id) DESC LIMIT :n
    SQL
  end

  def iniitalize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

end
