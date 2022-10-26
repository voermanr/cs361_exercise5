# Exercise 6

class LaunchDiscussionWorkflow
  def initialize(discussion, host, participants_email_string)
    @discussion = discussion
    @host = host
    @participants_email_string = participants_email_string
    @participants = []
  end

  # Expects @participants array to be filled with User objects
  def run
    return unless valid?

    run_callbacks(:create) do
      ActiveRecord::Base.transaction do
        discussion.save!
        create_discussion_roles!
        @successful = true
      end
    end
  end

  def generate_participant_users_from_email_string
    return if @participants_email_string.blank?

    @participants_email_string.split.uniq.map do |email_address|
      User.new(email_address)
    end
  end

  # ...
end

discussion = Discussion.new(title: 'fake')
host = User.find(42)
participants = "fake1@example.com\nfake2@example.com\nfake3@example.com"

workflow = LaunchDiscussionWorkflow.new(discussion, host, participants)
workflow.generate_participant_users_from_email_string
workflow.run

# changed User class implementation
class User
  def initialize(email)
    @email_address = email.downcase
    @password = Devise.friendly_token
  end
end
