class Question
  attr_accessor :title, :body, :author_id

  def self.find_by_id(id)
    result = QuestionsDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id
    SQL

    Question.new(result)

  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.execute(<<-SQL, author_id: author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = :author_id
    SQL
    results.map { |result| Question.new(result) }
  end

  def self.most_followed(n)
    QuestionFollow::most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike::most_liked_questions(n)
  end

  def self.all
    QuestionsDatabase.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
    SQL
  end

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    QuestionsDatabase.get_first_row(<<-SQL, author_id: @author_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :author_id
    SQL
  end

  def replies
    question_id = QuestionsDatabase.get_first_row(<<-SQL, title: @title, body: @body )
      SELECT
        id
      FROM
        questions
      WHERE
        title = :title AND
        body = :body
    SQL
    id_num = question_id['id']
    Reply::find_by_question_id(id_num)
  end

  def followers
    QuestionFollow::followers_for_question_id(@id)
  end

  def num_likes
    QuestionLike::num_likes_for_question_id(@id)
  end

  def likers
    QuestionLike::likers_for_question_id(@id)
  end

  def save
    if @id.nil?
      QuestionsDatabase.execute(<<-SQL, title: @title, body: @body, author_id: @author_id)
        INSERT INTO
          questions (title, body, author_id)
        VALUES
          (:title, :body, :author_id)
      SQL
      @id = QuestionsDatabase.last_insert_row_id
    else
      QuestionsDatabase.execute(<<-SQL, id: @id, title: @title, body: @body, author_id: @author_id)
        UPDATE
          questions
        SET
          title = :title,
          body = :body,
          author_id = :author_id
        WHERE
          id = :id
      SQL
    end
  end

end
