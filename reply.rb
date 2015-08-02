class Reply

  def self.find_by_id(id)
    result = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :id
    SQL
    Reply.new(result)
  end

  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    results.map { |result| Reply.new(result) }
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = :question_id
    SQL
    results.map { |result| Reply.new(result) }
  end

  def self.all
    QuestionsDatabase.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
    SQL
  end

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    QuestionsDatabase.get_first_row(<<-SQL, user_id: @user_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :user_id
    SQL
  end

  def question
    QuestionsDatabase.get_first_row(<<-SQL, question_id: @question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :question_id
    SQL
  end

  def parent_reply
    QuestionsDatabase.get_first_row(<<-SQL, parent_id: @parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :parent_id
    SQL
  end

  def child_replies
    QuestionsDatabase.execute(<<-SQL, id_num: @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = :id_num
    SQL
  end

  def save
    if @id.nil?
      QuestionsDatabase.execute(<<-SQL, question_id: @question_id, parent_id: @parent_id, user_id: @user_id, body: @body)
        INSERT INTO
          replies (question_id, parent_id, user_id, body)
        VALUES
          (:question_id, :parent_id, :user_id, :body)
      SQL
      @id = QuestionsDatabase.last_insert_row_id
    else
      QuestionsDatabase.execute(<<-SQL, id: @id, question_id: @question_id, parent_id: @parent_id, user_id: @user_id, body: @body)
        UPDATE
          replies
        SET
          question_id = :question_id,
          parent_id = :parent_id,
          user_id = :user_id,
          body = :body
        WHERE
          id = :id
      SQL
    end
  end

end
