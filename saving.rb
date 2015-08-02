require 'active_support/inflector'

module SaveModule

  def save
    ivars = instance_variables
    non_id_ivars = ivars.drop(1)
    id_ivars = ivars.take(1)

    instance_vals = self.instance_variables.map { |var| self.instance_variable_get(var)}
    non_id_instance_vals = instance_vals.drop(1)
    id_instance_vals = instance_vals.take(1)

    table_name = self.class.to_s.pluralize.downcase

    params_insert = non_id_ivars.map {|var| "?"}.join(", ")
    params_into = non_id_ivars.map {|var| var.to_s.tr("@","") }.join(", ")
    params_update = non_id_ivars.map { |var| "#{var} = ?" }.join(", ")

    if @id.nil?
      QuestionsDatabase.execute(<<-SQL, non_id_instance_vals)
        INSERT INTO
          #{table_name} #{params_into}
        VALUES
          #{params_insert}
      SQL
      @id = QuestionsDatabase.last_insert_row_id
    else
      QuestionsDatabase.execute(<<-SQL, non_id_instance_vals)
        UPDATE
          #{table_name}
        SET
          #{params_update}
        WHERE
          id = #{id_instance_vals}
      SQL
    end
  end


end
