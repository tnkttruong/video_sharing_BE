class V1::Videos::CreateOperation < ApplicationOperation
  def call
    validation!
    create_video
  end

  private
  def validation!
    @form = V1::Videos::CreateForm.new(url: params[:url])
    form.valid!
  end

  def create_video
    form.video.user_id = current_user.id
    form.video.save
  end
end
