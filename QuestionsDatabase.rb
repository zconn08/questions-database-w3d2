require_relative 'reply'
require_relative 'user'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_likes'

require 'sqlite3'
require 'singleton'
require 'byebug'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end

  def self.execute(*args)
    QuestionsDatabase.instance.execute(*args)
  end

  def self.get_first_row(*args)
    QuestionsDatabase.instance.get_first_row(*args)
  end

  def self.last_insert_row_id(*args)
    QuestionsDatabase.instance.last_insert_row_id(*args)
  end

end



kobe = User::find_by_id(3)
# p kobe.authored_questions
# p QuestionLike.num_likes_for_question_id(2)
p kobe.average_karma
# q1 = Question::find_by_id(1)
# p q1.followers
# r1 = Reply::find_by_id(1)
# p r1
# p r1.child_replies

# p QuestionLike::most_liked_questions(2)
