class ProjectsController < ApplicationController
  before_filter :require_login, only:[:new, :create, :destroy] 

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if @project.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
    if current_user
      @comment = @project.comments.build
      @pledge = @project.pledges.build
    end
  end

  def destroy
    @project = Project.find(params[:id])

    if @project.user_id == current_user.id && @project.pledges.sum(:amount) ==0 &&  @project.end_date > Date.today
      @project.destroy
     redirect_to projects_url, :status => 301  
   else
     redirect_to projects_path
   end
  end

  def index
    @projects = Project.all
  end


  private
  def project_params

    params.require(:project).permit(:title, :description, :goal, :start_date, :end_date)
  end
end
